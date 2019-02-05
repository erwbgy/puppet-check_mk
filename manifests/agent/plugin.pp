define check_mk::agent::plugin (
	$config = undef,
	$config_file = undef,
	$config_file_template = undef,
	$version = 'installed',
	$package_name = "${check_mk::agent::install::package_name}-${name}"
) {
	package { "${package_name}":
      ensure   => present,
      require => Package["$check_mk::agent::install::package_name"],
    }
	
	if $config_file {
		if $config_file_template
		{
			file { "${config_file}":
				owner   => 'root',
				group   => 'root',
				mode    => '0444',
				ensure  => present,
				content => template($config_file_template)
			}
		}
		elsif $config
		{
			file { "${config_file}":
				owner   => 'root',
				group   => 'root',
				mode    => '0444',
				ensure  => present,
				content => "${config}"
			}
		}
	}
}