class smokeping::install {
    if smokeping::manage_package {
      package { 'smokeping':
          ensure => $smokeping::version
      }
    }

    # correct permissions
    file {
        $smokeping::path_datadir:
            ensure  => directory,
            owner   => $smokeping::daemon_user,
            group   => $smokeping::daemon_group,
            require => Package['smokeping'],
            recurse => true;
        $smokeping::path_piddir:
            ensure  => directory,
            owner   => $smokeping::daemon_user,
            group   => $smokeping::daemon_group,
            require => Package['smokeping'],
            recurse => true;
        $smokeping::path_imgcache:
            ensure  => directory,
            owner   => $smokeping::webserver_user,
            group   => $smokeping::webserver_group,
            require => Package['smokeping'],
            recurse => true;
    }

}
