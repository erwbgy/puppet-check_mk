# == Class: check_mk::agent::config
#
# Configure check_mk agent.
#
# === Parameters
#
# [*ip_whitelist*]
#   Array of IP allowed to access the check_mk agent.
#   Default: undef
#
# [*port*]
#   Check_mk port
#   Default: undef
#
# [*server_dir*]
#   Check_mk server directory.
#   Default: undef
#
# [*use_cache*]
#   Enable cache.
#   Default: undef
#
# [*user*]
#   Check_mk user.
#   Default: undef
#
class check_mk::agent::config (
  $ip_whitelist = $check_mk::agent::ip_whitelist,
  $port         = $check_mk::agent::port,
  $server_dir   = $check_mk::agent::server_dir,
  $use_cache    = $check_mk::agent::use_cache,
  $user         = $check_mk::agent::user,
) inherits check_mk::agent {
  if $use_cache {
    $server = "${server_dir}/check_mk_caching_agent"
  } else {
    $server = "${server_dir}/check_mk_agent"
  }

  if $ip_whitelist {
    $only_from = join($ip_whitelist, ' ')
  } else {
    $only_from = undef
  }

  $xinetd_file = $::osfamily ? {
    'RedHat' => '/etc/xinetd.d/check-mk-agent',
    default  => '/etc/xinetd.d/check_mk',
  }

  file { $xinetd_file:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('check_mk/agent/check_mk.erb'),
    require => Package['check_mk-agent'],
    notify  => Class['check_mk::agent::service'],
  }

  # Delete file from older check_mk package version
  if $::osfamily == 'RedHat' {
    file { '/etc/xinetd.d/check_mk':
      ensure => 'absent',
    }
  }
}

# vim: set et sta sw=2 ts=2 sts=2 noci noai:a
