class check_mk::agent::install (
  $version = "present",
  $filestore,
  $workspace,
  $package_name = "check_mk-agent",
  
) {
  if ! defined(Package['xinetd']) {
    package { 'xinetd':
      ensure => present,
    }
  }
  if $filestore {
    if ! defined(File[$workspace]) {
      file { $workspace:
        ensure => directory,
      }
    }
    file { "${workspace}/check-mk-agent-${version}.noarch.rpm":
      ensure  => present,
      source  => "${filestore}/check-mk-agent-${version}.noarch.rpm",
      require => Package['xinetd'],
    }

    package { "${package_name}":
      ensure   => present,
      provider => 'rpm',
      source   => "${workspace}/${package_name}-${version}.noarch.rpm",
      require  => File["${workspace}/${package_name}-${version}.noarch.rpm"],
    }

  }
  else {
    package { "${package_name}":
      ensure  => $version,
      require => Package['xinetd'],
    }
  }
}
