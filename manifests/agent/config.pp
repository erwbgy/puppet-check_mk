# Class check_mk::agent::config
#
# Configure check_mk agent
#
class check_mk::agent::config (
  $ip_whitelist = $check_mk::agent::ip_whitelist,
  $port         = $check_mk::agent::port,
  $server_dir   = $check_mk::agent::server_dir,
  $use_cache    = $check_mk::agent::use_cache,
  $user         = $check_mk::agent::user,
) {
  if $ip_whitelist {
    $only_from = join($ip_whitelist, ' ')
  } else {
    $only_from = undef
  }

  case $::kernel {
    linux: {
      if $use_cache {
        $server = "${server_dir}/check_mk_caching_agent"
      }
      else {
        $server = "${server_dir}/check_mk_agent"
      }
      xinetd::service { 'check_mk':
        port         => $port,
        server       => $server,
        user         => $user,
        only_from    => $only_from,
        service_type => 'UNLISTED'
      }
      xinetd::service { 'check-mk-agent':
        ensure => 'absent',
        port   => $port,
        server => $server,
      }
    }
    default: {
      file { 'C:/Program Files (x86)/check_mk/check_mk.ini':
        content => template('check_mk/agent/check_mk.ini.erb'),
      }
    }
  }
}
