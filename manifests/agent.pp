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
  $windows_installer =
    'http://mathias-kettner.de/download/check-mk-agent-1.2.4p2.exe'
) {
  Class['check_mk::agent::install'] ->
  Class['check_mk::agent::config'] ~>
  Class['check_mk::agent::service'] ->
  Class['check_mk::agent']

  include check_mk::agent::install

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
