class check_mk::agent::config (
  $ip_whitelist,
  $port,
  $server_dir,
  $use_cache,
  $user,
) {
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
    notify  => Class['check_mk::agent::service'],
  }
}
