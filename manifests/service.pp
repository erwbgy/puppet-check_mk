class check_mk::service {
  if ! defined(Service[httpd]) {
    service { 'httpd':
      ensure => 'running',
      enable => true,
    }
  }
  # xinetd service handled by xinetd module
  service { 'omd':
    ensure => 'running',
    enable => true,
  }
}
