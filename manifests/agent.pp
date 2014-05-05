# Class: check_mk::agent
#
# Install and configure the check_mk::agent
#
class check_mk::agent (
  $filestore    = undef,
  $host_tags    = undef,
  $ip_whitelist = undef,
  $port         = '6556',
  $server_dir   = '/usr/bin',
  $use_cache    = false,
  $user         = 'root',
  $version      = undef,
  $workspace    = '/root/check_mk',
) {
  Class['check_mk::agent::install'] ->
  Class['check_mk::agent::config'] ~>
  Class['check_mk::agent::service']

  class { 'check_mk::agent::install':
    version                    => $version,
    filestore                  => $filestore,
    workspace                  => $workspace,
  }

  class { 'check_mk::agent::config':
    ip_whitelist => $ip_whitelist,
    port         => $port,
    server_dir   => $server_dir,
    use_cache    => $use_cache,
    user         => $user,
  }

  include check_mk::agent::service
  @@check_mk::host { $::fqdn:
    host_tags => $host_tags,
  }
}
