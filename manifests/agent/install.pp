class check_mk::agent::install (
  $version,
  $filestore,
  $workspace,
  $provider,
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
    if $provider == 'rpm' {
      $pkg_suffix = '${pkg_suffix}'
    } elsif $provider == 'dpkg' {
      $pkg_suffix = '_all.deb'
    } else {
      notify { 'Provider not recognized':}
    }
    file { "${workspace}/check_mk-agent-${version}${pkg_suffix}":
      ensure  => present,
      source  => "${filestore}/check_mk-agent-${version}${pkg_suffix}",
      require => Package['xinetd'],
    }
    file { "${workspace}/check_mk-agent-logwatch-${version}${pkg_suffix}":
      ensure  => present,
      source  => "${filestore}/check_mk-agent-logwatch-${version}${pkg_suffix}",
      require => Package['xinetd'],
    }
    package { 'check_mk-agent':
      ensure   => present,
      provider => $provider,
      source   => "${workspace}/check_mk-agent-${version}${pkg_suffix}",
      require  => File["${workspace}/check_mk-agent-${version}${pkg_suffix}"],
    }
    package { 'check_mk-agent-logwatch':
      ensure   => present,
      provider => $provider,
      source   => "${workspace}/check_mk-agent-logwatch-${version}${pkg_suffix}",
      require  => [
        File["${workspace}/check_mk-agent-logwatch-${version}${pkg_suffix}"],
        Package['check_mk-agent'],
      ],
    }
  }
  else {
    package { 'check_mk-agent':
      ensure  => present,
      require => Package['xinetd'],
    }
    package { 'check_mk-agent-logwatch':
      ensure  => present,
      require => Package['check_mk-agent'],
    }
  }
}
