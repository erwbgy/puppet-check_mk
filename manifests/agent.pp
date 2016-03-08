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
  $package      = undef,
  $mrpe_checks  = {},
) {
  validate_hash($mrpe_checks)
  include check_mk::agent::install
  include check_mk::agent::config
  include check_mk::agent::service
  Class['check_mk::agent::install'] ->
  Class['check_mk::agent::config']
  @@check_mk::host { $::fqdn:
    host_tags => $host_tags,
  }
  create_resources('check_mk::agent::mrpe', $mrpe_checks)
}
