class check_mk::agent::install (
  $version,
  $filestore,
  $workspace,
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
    file { "${workspace}/check_mk-agent-logwatch-${version}.noarch.rpm":
      ensure  => present,
      source  => "${filestore}/check_mk-agent-logwatch-${version}.noarch.rpm",
      require => Package['xinetd'],
    }
    package { 'check_mk-agent':
      ensure   => present,
      provider => 'rpm',
      source   => "${workspace}/check_mk-agent-${version}.noarch.rpm",
      require  => File["${workspace}/check_mk-agent-${version}.noarch.rpm"],
    }
    package { 'check_mk-agent-logwatch':
      ensure   => present,
      provider => 'rpm',
      source   => "${workspace}/check_mk-agent-logwatch-${version}.noarch.rpm",
      require  => [
        File["${workspace}/check_mk-agent-logwatch-${version}.noarch.rpm"],
        Package['check_mk-agent'],
      ],
    }
  }
  else {
    $check_mk_agent = $::osfamily ? {
      'Debian' => 'check-mk-agent',
      default  => 'check_mk-agent',
    }
    $check_mk_agent_logwatch = $::osfamily ? {
      'Debian' => 'check-mk-agent-logwatch',
      default  => 'check_mk-agent-logwatch',
    }
    package { 'check_mk-agent':
      ensure  => present,
      name    => $check_mk_agent,
      require => Package['xinetd'],
    }
    package { 'check_mk-agent-logwatch':
      ensure  => present,
      name    => $check_mk_agent_logwatch,
      require => Package['check_mk-agent'],
    }
  }
}
