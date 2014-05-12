# Class: check_mk::agent::service
#
# Make sure xinetd is running on Linux or the Check_MK_Agent Service
# on windows.
#
class check_mk::agent::service {
  case $::kernel {
    linux: {
      # Service done by xinetd module
    }
    windows: {
      service { 'Check_MK_Agent':
        ensure => 'running'
      }
    }
    default: {
      # Nothing to do
    }
  }
}
