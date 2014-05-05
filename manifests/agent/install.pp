# Class: check_mk::agent::install
#
# Install the check_mk::agent
#
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
    case $::operatingsystem {
      centos, redhat: {
        $check_mk_agent_packagename = 'check-mk-agent'
        # Redhat/CentOS Package has logwatch build in
        $check_mk_agent_logwatch_packagename = undef
      }
      debian, ubuntu: {
        $check_mk_agent_packagename = 'check_mk-agent'
        $check_mk_agent_logwatch_packagename = 'check_mk-agent-logwatch'
      }
      default: {
        fail('Unsupported operating system in check_mk::agent')
      }
    }
    package { $check_mk_agent_packagename:
      ensure  => present,
      require => Package['xinetd'],
    }
    if ( $check_mk_agent_logwatch_packagename ) {
      package { $check_mk_agent_logwatch_packagename:
        ensure  => present,
        require => Package[$check_mk_agent_packagename]
      }
    }
  }
}
