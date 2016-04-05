class check_mk::service (
  $checkmk_service,
  $httpd_service, 
) {
  if ! defined(Service[$httpd_service]) {
    service { "$httpd_service":
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
  service { $checkmk_service:
    ensure => 'running',
    enable => true,
  }
}
