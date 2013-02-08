class check_mk::config (
  site,
  host_groups = undef,
) {
  $etc_dir = "/omd/sites/${site}/etc"
  $bin_dir = "/omd/sites/${site}/bin"
  exec { 'omd-create-site':
    command => "/usr/bin/omd create ${site}",
    creates => $etc_dir,
  }
  file { "${etc_dir}/nagios/local":
    ensure => directory,
  }
  file_line { 'nagios-add-check_mk-cfg_dir':
    ensure  => present,
    line    => "cfg_dir=${etc_dir}/nagios/local",
    path    => "${etc_dir}/nagios/nagios.cfg",
    require => File["${etc_dir}/nagios/local"],
    notify  => Class['check_mk::service'],
  }
  file_line { 'add-guest-users':
    ensure => present,
    line   => 'guest_users = [ "guest" ]',
    path   => "${etc_dir}/check_mk/multisite.mk",
    notify => Class['check_mk::service'],
  }
  concat { "${etc_dir}/check_mk/main.mk":
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['check_mk-refresh'],
  }
  # all_hosts
  concat::fragment { 'all_hosts-header':
    target  => "${etc_dir}/check_mk/main.mk",
    content => "all_hosts = [\n",
    order   => 10,
  }
  concat::fragment { 'all_hosts-footer':
    target  => "${etc_dir}/check_mk/main.mk",
    content => "]\n",
    order   => 19,
  }
  Check_mk::Host <<| |>> {
    target => "${etc_dir}/check_mk/main.mk",
    notify => Exec['check_mk-refresh']
  }
  # host_groups
  if $host_groups {
    file { "${etc_dir}/nagios/local/hostgroups":
      ensure => directory,
    }
    concat::fragment { 'host_groups-header':
      target  => "${etc_dir}/check_mk/main.mk",
      content => "host_groups = [\n",
      order   => 20,
    }
    concat::fragment { 'host_groups-footer':
      target  => "${etc_dir}/check_mk/main.mk",
      content => "]\n",
      order   => 29,
    }
    check_mk::hostgroup { keys($host_groups):
      dir         => "${etc_dir}/nagios/local/hostgroups",
      host_groups => $host_groups,
      target      => "${etc_dir}/check_mk/main.mk",
      notify      => Exec['check_mk-refresh']
    }
  }
  # local config is in /omd/sites/${site}/etc/check_mk/main.mk.local and is appended
  concat::fragment { 'check_mk-local-config':
    target  => "${etc_dir}/check_mk/main.mk",
    ensure  => "${etc_dir}/check_mk/main.mk.local",
    order   => 99,
  }
  # re-read config if it changes
  exec { 'check_mk-refresh':
    command     => "${bin_dir}/check_mk -I",
    refreshonly => true,
    notify      => Exec['check_mk-reload'],
  }
  exec { 'check_mk-reload':
    command     => "${bin_dir}/check_mk -O",
    refreshonly => true,
  }
  # re-read inventory at least daily
  exec { 'check_mk-refresh-inventory-daily':
    command  => "${bin_dir}/cmk -I",
    schedule => 'daily',
  }
}
