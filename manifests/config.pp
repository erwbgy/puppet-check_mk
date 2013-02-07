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
  Check_mk::Host <<| |>> { notify => Exec['check_mk-restart'] }
  #file { '/etc/check_mk/main.mk':
  #  ensure => present,
  #  content => "all_hosts = [ 'lnxmgt-01.sbetenv.ads' ]",
  #  notify => Exec['check_mk-restart'],
  #}
  exec { 'check_mk-restart':
    command     => '/usr/bin/check_mk -O',
    refreshonly => true,
  }
  # TODO:
  # /etc/check_mk/main.mk
  # all_hosts = [
  #  'lnxmgt-01.sbetenv.ads',
  #  'lnxmgt-02.sbetenv.ads',
  # ]
  # # cmk -I
  # # check_mk -O
}
