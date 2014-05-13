# Class check_mk::agent::config
#
# Configure check_mk agent
#
class check_mk::agent::config (
  #  $ip_whitelist = $check_mk::agent::ip_whitelist,
  $ip_whitelist = ['192.168.20.1'],
  $port         = $check_mk::agent::port,
  $server_dir   = $check_mk::agent::server_dir,
  $use_cache    = $check_mk::agent::use_cache,
  $user         = $check_mk::agent::user,
) {
  case $::kernel {
    linux: {
      if $use_cache {
        $server = "${server_dir}/check_mk_caching_agent"
      }
      else {
        $server = "${server_dir}/check_mk_agent"
      }
      if $ip_whitelist {
        $ip_whitelist_string = join($ip_whitelist, ' ')
        $only_from = "127.0.0.1 ${ip_whitelist_string}"
      } else {
        $only_from = undef
      }
      xinetd::service { 'check_mk':
        port      => $port,
        server    => $server,
        user      => $user,
        only_from => $only_from
      }
      xinetd::service { 'check-mk-agent':
        ensure => 'absent',
        port   => $port,
        server => $server,
      }
    }
    default: {
      # Skipping Configuration for non linux
    }
  }
}
