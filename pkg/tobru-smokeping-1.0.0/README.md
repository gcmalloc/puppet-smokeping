# SmokePing Puppet module

Puppet module to completely manage a SmokePing installation.
Includes managing of Master/Slave installation and the menu hierarchy.

## Features

* Master/Slave SmokePing configuration possible
* Menu hierarchy implemented
* Define Probes and Alert patterns
* Config files managed with templates
* Uses exported resources to configure Slaves on the Master (tag: smokeping-slave)
* Automatically generates a shared secret for Master/Slave configuration (tag: smokeping-slave-secret)

Tested on Ubuntu 12.04 LTS

## Dependencies
  - [puppet-concat](https://github.com/ripienaar/puppet-concat)

## Example

### Master SmokePing instance
```puppet
# install a master instance on a server with default values (see init.pp for 
# parameter documentation
class { '::smokeping':
    mode => 'master',
}
```

### Slave SmokePing instance
```puppet
class { '::smokeping':
    mode           => 'slave',
    slave_name     => $::hostname,
    master_url     => 'http://myserver.tld/smokeping/smokeping.cgi',
    slave_location => 'zurich',
}
```
This configures the server as slaves and adds the slave definition automatically to the
master using exported resources.

### Probes
```puppet
$probes = [
    { name => 'FPing', binary => '/usr/bin/fping' },
    { name => 'FPing6', binary => '/usr/bin/fping6' },
]
Class['::smokeping'] {
  probes => $probes
}
```

### Alerts
```puppet
$alerts = [ {
  { name    => 'bigloss',
  type    => 'loss',
  pattern => '==0%,==0%,==0%,==0%,>0%,>0%,>0%',
  comment => 'suddenly there is packet loss' },

  { name    => 'startloss',
  type    => 'loss',
  pattern => '==S,>0%,>0%,>0%',
  comment => 'loss at startup' },

  { name    => 'noloss',
  type    => 'loss',
  pattern => '>0%,>0%,>0%,==0%,==0%,==0%,==0%',
  comment => 'there was loss and now its reachable again' },
] }
Class['::smokeping'] {
  alerts => $alerts
}
```

### Targets
```puppet
# Top Level
smokeping::target { 'World':
    menu      => 'World',
    pagetitle => 'Connection to the World',
    alerts    => [ 'bigloss', 'noloss' ]
}

smokeping::target { 'GoogleCH':
    hierarchy_parent => 'World',
    hierarchy_level  => 2,
    menu             => 'google.ch',
    pagetitle        => 'Google',
}
smokeping::target { 'GoogleCHIPv4':
    hierarchy_parent => 'GoogleCH',
    hierarchy_level  => 3,
    menu             => 'google.ch IPv4',
    host             => 'google.ch',
    slaves           => ['slave1'],
}
smokeping::target { 'GoogleCHIPv6':
    hierarchy_parent => 'GoogleCH',
    hierarchy_level  => 3,
    menu             => 'google.ch IPv6',
    host             => 'google.ch',
    probe            => 'FPing6'
    slaves           => ['slave1'],
}
```

## License / Author

The module is written by

* Tobias Brunner <tobias.brunner@nine.ch>

Licensed under Apache License, Version 2.0, Copyright 2013 by Tobias Brunner
