# check_mk

Puppet module for installing and configuring a Nagios server with check_mk and
check_mk agents.  Agent hostnames are automatically added to the server
all_hosts configuration using stored configs.

Currently only tested on Redhat-like systems.

## Server

* Installs nagios packages from EPEL.

* Unpacks the check_mk tarball and runs the setup script - this requires
installing the g++ compiler and related tools so if this is an issue then use
the OMD distribution instead (which you should probably use anyway for any
important setup).

* Populates the all_hosts array in /etc/check_mk/main.mk with hostnames
  exported by check::agent classes on agent hosts

### Example

    class { 'check_mk':
      version => '1.2.0p3'
    }

### check_mk parameters

*version*: The version in the check_mk tarball - for example if the tarball is
'check_mk-1.2.0p3.tar.gz' then the version is '1.2.0p3'. REQUIRED.

*filestore*: The location of the tarball.  Default: 'puppet:///files/check_mk'

*workspace*: The directory to use to store files used during installation.
Default: '/root/check_mk'

## Agent

* Installs the check_mk-agent and check_mk-agent-logwatch RPMs

* Configures the /etc/xinetd.d/check_mk configuration file

### Example

    class { 'check_mk::agent':
      version => '1.2.0p3-1',
      ip_whitelist => [ '10.7.96.21', '10.7.96.22' ],
    }

### check_mk::agent parameters

*version*: The version in the check_mk packages - for example if the RPM is
'check_mk-agent-1.2.0p3-1.noarch.rpm' then the version is '1.2.0p3-1'.
REQUIRED.

*filestore*: The location of the tarball.  Default: 'puppet:///files/check_mk'

*ip_whitelist*: The list of IP addresses that are allowed to retrieve check_mk
data. (Note that localhost is always allowed to connect.) By default any IP can
connect.

*port*: The port the check_mk agent listens on. Default: '6556'

*server_dir*: The directory in which the check_mk_agent executable is located.
Default: '/usr/bin'

*use_cache*: Whether or not to cache the results - useful with redundant
monitoring server setups.  Default: 'false'

*user*: The user that the agent runs as. Default: 'root'

*workspace*: The directory to use to store files used during installation.
Default: '/root/check_mk'

