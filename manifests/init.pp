class check_mk (
  $filestore = undef,
  $package   = 'omd',
  $site      = 'monitoring',
  $workspace = '/root/check_mk',
) {
  class { 'check_mk::install':
    filestore => $filestore,
    package   => $package,
    site      => $site,
    workspace => $workspace,
  }
  class { 'check_mk::config':
    site      => $site,
    require   => Class['check_mk::install'],
  }
  class { 'check_mk::service':
    require   => Class['check_mk::config'],
  }
}
