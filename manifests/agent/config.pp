# Class check_mk::agent::config
#
# Configure check_mk agent
#
class check_mk::agent::config (
  $ip_whitelist,
  $port,
  $server_dir,
  $use_cache,
  $user,
) {
  if $use_cache {
    $server = "${server_dir}/check_mk_caching_agent"
  }
  else {
    $server = "${server_dir}/check_mk_agent"
  }
  if $ip_whitelist {
    $only_from = join($ip_whitelist, ' ')
  }
  else {
    $only_from = undef
  }
  file { '/etc/xinetd.d/check_mk':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('check_mk/agent/check_mk.erb'),
    notify  => Class['check_mk::agent::service'],
  }
  # Avoid duplicate file created from package install
  file { '/etc/xinet.d/check-mk-agent':
    ensure => absent,
    notify  => Class['check_mk::agent::service'],
  }
}
