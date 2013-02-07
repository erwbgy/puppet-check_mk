class check_mk::config {
  file_line { 'nagios-remove-localhost':
    ensure => absent,
    line   => 'cfg_file=/etc/nagios/objects/localhost.cfg',
    path   => '/etc/nagios/nagios.cfg',
    notify => Class['check_mk::service'],
  }
  file_line { 'nagios-add-check_mk-cfg_dir':
    ensure => present,
    line   => 'cfg_dir=/etc/nagios/check_mk',
    path   => '/etc/nagios/nagios.cfg',
    notify => Class['check_mk::service'],
  }
  concat { '/etc/check_mk/main.mk':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['check_mk-refresh'],
  }
  concat::fragment { 'all_hosts-header':
    target  => '/etc/check_mk/main.mk',
    content => "all_hosts = [\n",
    order   => 01,
  }
  concat::fragment { 'all_hosts-footer':
    target  => '/etc/check_mk/main.mk',
    content => "]\n",
    order   => 03,
  }
  Check_mk::Host <<| |>> { notify => Exec['check_mk-refresh'] }
  exec { 'check_mk-refresh':
    command     => '/usr/bin/check_mk -I',
    refreshonly => true,
    notify      => Exec['check_mk-reload'],
  }
  exec { 'check_mk-reload':
    command     => '/usr/bin/check_mk -O',
    refreshonly => true,
  }
}
