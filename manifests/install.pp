class check_mk::install (
  $filestore,
  $package,
  $site,
  $workspace,
) {
  if $filestore {
    if ! defined(File[$workspace]) {
      file { $workspace:
        ensure => directory,
      }
    }
    file { "${workspace}/${package}":
      ensure  => present,
      source  => "${filestore}/${package}",
      require => File[$workspace],
    }
    if $package =~ /^omd-(.*?)\.(rpm|deb)$/ {
      $type = $2
      package { $package:
        ensure   => installed,
        provider => $type,
        source   => "${workspace}/${package}",
        require  => File["${workspace}/${package}"],
      }
    }
  }
  else {
    package { $package:
      ensure => installed,
    }
  }
  $etc_dir = "/omd/sites/${site}/etc"
  exec { 'omd-create-site':
    command => "/usr/bin/omd create ${site}",
    creates => $etc_dir,
    require => Package[$package],
  }
}
