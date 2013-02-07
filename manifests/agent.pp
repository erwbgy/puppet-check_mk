class check_mk::agent (
  $version,
  $filestore    = 'puppet:///files/check_mk',
  $ip_whitelist = undef,
  $port         = '6556',
  $server_dir   = '/usr/bin',
  $use_cache    = false,
  $user         = 'root',
  $workspace    = '/root/check_mk',
) {
  if ! defined(Package['xinetd']) {
    package { 'xinetd':
      ensure => present,
    }
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
    require  => File["${workspace}/check_mk-agent-logwatch-${version}.noarch.rpm"],
  }
  if $use_cache {
    $server = "${server_dir}/check_mk_caching_agent"
  }
  else {
    $server = "${server_dir}/check_mk_agent"
  }
  if $ip_whitelist {
    $only_from = join($ip_whitelist, ' ')
  }
  else {
    $only_from = undef
  }
  file { '/etc/xinetd.d/check_mk':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('check_mk/agent/check_mk.erb'),
    require => Package['check_mk-agent','check_mk-agent-logwatch'],
    notify  => Service['xinetd'],
  }
  if ! defined(Service['xinetd']) {
    service { 'xinetd':
      ensure => 'running',
      enable => true,
    }
  }
}
