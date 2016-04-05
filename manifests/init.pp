class check_mk (
  $checkmk_service  = $checkmk::params::checkmk_service,
  $filestore        = $checkmk::params::filestore
  $host_groups      = $checkmk::params::host_groups,
  $httpd_service    = $checkmk::params::httpd_service,
  $package          = $checkmk::params::package,
  $site             = $checkmk::params::site,
  $workspace        = $checkmk::params::workspace,
) {
  class { 'check_mk::install':
    filestore => $filestore,
    package   => $package,
    site      => $site,
    workspace => $workspace,
  }
  class { 'check_mk::config':
    host_groups => $host_groups,
    site        => $site,
    require     => Class['check_mk::install'],
  }
  class { 'check_mk::service':
    checmk_service => $checkmk_service,
    httpd_service  => $httpd_service,
    require        => Class['check_mk::config'],
  }
}
