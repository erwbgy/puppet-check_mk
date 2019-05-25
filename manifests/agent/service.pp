class check_mk::agent::service {
  if ! defined(Service['xinetd']) {
    if $::operatingsystem == 'Debian' and
    versioncmp($::operatingsystemmajrelease, '7') == 0 {
      service { 'xinetd':
        ensure    => 'running',
        enable    => true,
        hasstatus => false,
      }
    } else {
      service { 'xinetd':
        ensure => 'running',
        enable => true,
      }
    }
  }
}
