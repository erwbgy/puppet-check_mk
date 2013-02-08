# check_mk

Puppet module for:

* Installing and configuring the Open Monitoring Distribution (OMD) which
  includes Nagios, check_mk and lots of other tools

* Installing and configuring check_mk agents

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

Installs the 'monitoring' package from the system repository. The default 'monitoring' site is used.

### Example 2

    class { 'check_mk':
      filestore => 'puppet:///files/check_mk',
      package   => 'omd-0.56-rh60-29.x86_64.rpm'
    }

Installs the specified omd package after retrieving it from the Puppet file store.

### Example 3

    class { 'check_mk':
      site => 'acme',
    }

Installs the omd package from the system repository.  A site called 'acme' is
created making the URL http://hostname/acme/check_mk/ running as the 'acme' user.

### check_mk parameters

*package*: The omd package (rpm or deb) to install. Optional.

*filestore*: The Puppet file store location where the package can be found (eg. 'puppet:///files/check_mk'). Optional.

*site*: The name of the omd site (and the user/group it runs as). Default: 'monitoring'

*workspace*: The directory to use to store files used during installation.  Default: '/root/check_mk'

### Notes

* A user and group with the same value as the site parameter is created.  By default this is 'monitoring'.

* The URL is http://yourhostname/sitename/check_mk/ - for example http://monhost.domain/monitoring/check_mk/

* The default username/password is omdadmin/omd. To change this or add additional users log in as the site user and run htpasswd - for example:

    monitoring$ htpasswd -b ~/etc/htpasswd guest guest

* A user called 'guest' is configured as a guest user but is not enabled unless a password is set (as above).

## Agent

* Installs the check_mk-agent and check_mk-agent-logwatch packages

* Configures the /etc/xinetd.d/check_mk configuration file

### Example 1

    include check_mk::agent

Installs the check_mk and check_mk_logwatch packages from the system repository
and configures /etc/xinetd.d/check_mk with no IP whitelist restrictions.

### Example 2

    class { 'check_mk::agent':
      version => '1.2.0p3-1',
      ip_whitelist => [ '10.7.96.21', '10.7.96.22' ],
    }

Installs the specified versions of the check_mk and check_mk_logwatch packages
after retrieving them from the Puppet file store.  Configures
/etc/xinetd.d/check_mk so that only the specified IPs (and localhost/127.0.0.1)
are allowed to connect.

### check_mk::agent parameters

*filestore*: The Puppet file store location where the packages can be found (eg. 'puppet:///files/check_mk'). Optional.

*ip_whitelist*: The list of IP addresses that are allowed to retrieve check_mk
data. (Note that localhost is always allowed to connect.) By default any IP can
connect.

*port*: The port the check_mk agent listens on. Default: '6556'

*server_dir*: The directory in which the check_mk_agent executable is located.
Default: '/usr/bin'

*use_cache*: Whether or not to cache the results - useful with redundant
monitoring server setups.  Default: 'false'

*user*: The user that the agent runs as. Default: 'root'

*version*: The version in the check_mk packages - for example if the RPM is
'check_mk-agent-1.2.0p3-1.noarch.rpm' then the version is '1.2.0p3-1'.
Only required if a filestore is used.

*workspace*: The directory to use to store files used during installation.
Default: '/root/check_mk'

