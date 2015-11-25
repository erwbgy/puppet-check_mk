class check_mk::agent::install (
  $version,
  $filestore,
  $workspace,
  $package,
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
