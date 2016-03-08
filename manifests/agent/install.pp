class check_mk::agent::install (
  $version   = $check_mk::agent::version,
  $filestore = undef,
  $workspace = $check_mk::agent::workspace,
  $package   = undef,
) inherits check_mk::agent {
  if ! defined(Package['xinetd']) {
    package { 'xinetd':
      ensure => present,
    }
  }
  if $filestore {
    if ! $version {
      fail('version must be specified.')
    }

    if ! defined(File[$workspace]) {
      file { $workspace:
        ensure => directory,
      }
    }
    file { "${workspace}/check_mk-agent-${version}.noarch.rpm":
      ensure  => present,
      source  => "${filestore}/check_mk-agent-${version}.noarch.rpm",
      require => Package['xinetd'],
    }
    package { 'check_mk-agent':
      ensure   => present,
      provider => 'rpm',
      source   => "${workspace}/check_mk-agent-${version}.noarch.rpm",
      require  => File["${workspace}/check_mk-agent-${version}.noarch.rpm"],
    }
  }
  else {
    $check_mk_agent = $package ? {
      undef => $::osfamily ? {
        'Debian' => 'check-mk-agent',
        'RedHat' => 'check-mk-agent',
        default  => 'check_mk-agent',
      },
      default  => $package,
    }
    package { 'check_mk-agent':
      ensure  => present,
      name    => $check_mk_agent,
      require => Package['xinetd'],
    }
  }
}
