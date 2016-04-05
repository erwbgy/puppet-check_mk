class check_mk::params {
  # general settings
  $checkmk_service = 'omd'

  # OS specific
  case $::osfamily {
    'RedHat': {
      $httpd_service = 'httpd'
    }
    'Debian': {
      $httpd_service = 'apache2'
    }
  }
}
