class check_mk::params {

  # common variables
  $checkmk_service = 'omd'
  $package = 'omd-0.56'
  $filestore = undef
  $host_groups= undef
  $site = 'monitoring'
  $workspace = '/root/check_mk'

  # OS specific variables
  case $::osfamily {
    'RedHat': {
      $httpd_service = 'httpd'
    }
    'Debian': {
      $httpd_service = 'apache2'
    }
  }
}
