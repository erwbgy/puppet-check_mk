class check_mk::install (
  $filestore = undef,
  $package = undef,
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
    # omd-0.56-rh60-29.x86_64.rpm
    if $package =~ /^(omd-\d+\.\d+)-(.*?)\.(rpm|deb)$/ {
      $package_name = $1
      $type         = $3
      package { $package_name:
        ensure   => installed,
        provider => $type,
        source   => "${workspace}/${package}",
        require  => File["${workspace}/${package}"],
      }
    }
  }
  else {
    $package_name = $package
    package { $package_name:
      ensure => installed,
    }
  }
  $etc_dir = "/omd/sites/${site}/etc"
  exec { 'omd-create-site':
    command => "/usr/bin/omd create ${site}",
    creates => $etc_dir,
    require => Package[$package_name],
  }
}
