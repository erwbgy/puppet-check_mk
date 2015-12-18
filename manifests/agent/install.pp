# Class: check_mk::agent::install
#
# Install the check_mk::agent
#
class check_mk::agent::install (
  $version = $check_mk::agent::version,
  $filestore = $check_mk::agent::filestore,
  $workspace = $check_mk::agent::workspace,
  $windows_installer = $check_mk::agent::windows_installer,
) {

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
      windows: {
        # Nothing
      }
      default: {
        fail("Unsupported OS in check_mk::agent - ${::operatingsystem}")
      }
    }
    case $::kernel {
      linux: {
        include xinetd

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
      windows: {
        # Windows might have c:\temp or c:\tmp
        # Playing it safe using c:\
        exec {'Download check_mk_agent':
          command  => "\$client = new-object System.Net.WebClient; \$client.DownloadFile('${windows_installer}','C:\\check_mk_agent.exe')",
          creates  => 'C:/check_mk_agent.exe',
          provider => 'powershell'
        }
        exec {'Install check_mk_agent':
          command => 'C:\\check_mk_agent.exe /S',
          creates => 'C:\\Program Files (x86)\\check_mk\\check_mk_agent.exe',
          require => Exec['Download check_mk_agent']
        }
      }
      default: {
        fail("Unsupported kernel in check_mk::agent::install - ${::kernel}")
      }
    }
  }
}
