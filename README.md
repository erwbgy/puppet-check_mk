# check_mk

Puppet module for:

* Installing and configuring the Open Monitoring Distribution (OMD) which
  includes Nagios, check_mk and lots of other tools

* Installing check_mk agents.

Agent hostnames are automatically added to the server all_hosts configuration
using stored configs.

Currently only tested on Redhat-like systems.

## Server

* Installs omd package either using the system repository (eg. yum, apt) or
  from a package file retrieved from the Puppet file store

* Populates the all_hosts array in /etc/check_mk/main.mk with hostnames
  exported by check::agent classes on agent hosts

### Example 1

    include check_mk

Installs the 'omd' package from the system repository. The default 'omd' site is used.

### Example 2

    class { 'check_mk':
      filestore => 'puppet:///files/check_mk',
      package   => 'omd-0.56-rh60-29.x86_64.rpm'
    }

Installs the specified 'omd' package after retrieving it from the Puppet file store.

### Example 3

    class { 'check_mk':
      site => 'acme',
    }

Installs the 'omd' package from the system repository.  A site called 'acme' is
used making the URL http://hostname/acme/check_mk/

### check_mk parameters

*package*: The omd package (rpm or deb) to install. Optional.

*filestore*: The Puppet file store location where the package can be found (eg. 'puppet:///files/check_mk'). Optional.

*workspace*: The directory to use to store files used during installation.  Default: '/root/check_mk'

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

