class mysql {
  
  package { "mysql-server":
    ensure => installed,
  }
  
  file {"/etc/mysql/conf.d/allow_external.cnf":
    owner   => mysql,
    group   => mysql,
    mode    => 0644,
    content => template("database/etc/mysql/conf.d/allow_external.cnf"),
    require => Package["mysql-server"],
    notify     => Service["mysql"]
  }

  service {"mysql":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package["mysql-server"],
  }

  
}