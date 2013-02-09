class check_mk (
  $filestore   = undef,
  $host_groups = undef,
  $package     = 'omd-0.56',
  $site        = 'monitoring',
  $workspace   = '/root/check_mk',
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
    require   => Class['check_mk::config'],
  }
}
