class check_mk::service {
  if ! defined(Service[httpd]) {
    service { 'httpd':
      ensure => 'running',
      enable => true,
    }
  }
  if ! defined(Service[xinetd]) {
    service { 'xinetd':
      ensure => 'running',
      enable => true,
    }
  }
  service { 'omd':
    ensure => 'running',
    enable => true,
  }
}
