class check_mk::install (
  $filestore,
  $package,
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
      $type = $1
      package { 'omd':
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
}
