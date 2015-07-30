class check_mk::agent::install (
  $version,
  $filestore,
  $workspace,
  $package_checkmk_ensure = "present",
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

    package { 'check-mk-agent':
      ensure   => present,
      provider => 'rpm',
      source   => "${workspace}/check-mk-agent-${version}.noarch.rpm",
      require  => File["${workspace}/check-mk-agent-${version}.noarch.rpm"],
    }

  }
  else {
    package { 'check-mk-agent':
      ensure  => $package_checkmk_ensure,
      require => Package['xinetd'],
    }
  }
}
