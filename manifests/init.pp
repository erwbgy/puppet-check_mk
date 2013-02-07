class check_mk (
  $version,
  $filestore = 'puppet:///files/check_mk',
  $workspace = '/root/check_mk',
) {
  if ! defined(File[$workspace]) {
    file { $workspace:
      ensure => directory,
    }
  }
  class { 'check_mk::install':
    filestore => $filestore,
    version   => $version,
    workspace => $workspace,
    require   => File[$workspace],
  }
  class { 'check_mk::config':
    require   => Class['check_mk::install'],
  }
  class { 'check_mk::service':
    require   => Class['check_mk::config'],
  }
}
