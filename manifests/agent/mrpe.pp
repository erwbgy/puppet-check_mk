#
# Add entry to the mrpe.cfg file
#
### Parameters
#
### command
#
# The command to run
#
### Example
#
# ```
# check_mk::agent::mrpe { 'Test':
#   command => '/bin/true'
# }
# ```
#
## Authors
#
# * Bas Grolleman <bgrolleman@emendo-it.nl>
#
define check_mk::agent::mrpe (
  $command,
) {
  $mrpe_config_file = $::operatingsystem ? {
    centos  => '/etc/check-mk-agent/mrpe.cfg',
    redhat  => '/etc/check-mk-agent/mrpe.cfg',
    default => undef,
  }

  if ( $mrpe_config_file ) {
    if ! defined(Concat[$mrpe_config_file]) {
      concat { $mrpe_config_file:
        ensure => 'present',
      }
    }
    concat::fragment { "${name}-mrpe-check":
      target  => $mrpe_config_file,
      content => "${name} ${command}\n",
    }
  } else {
    fail("Creating mrpe.cfg is unsupported for operatingsystem ${::operatingsystem}")
  }
}
