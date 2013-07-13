define opencart-app-setup() {
 
  package {"wget":
    ensure => installed,
  }

  exec {"has-opencart.deb":
    command => "/usr/bin/wget http://j.mp/opencart-deb -O /tmp/opencart.deb",
    creates => "/tmp/opencart.deb",
    require => Package["wget"],
  }

  package {"opencart":
    provider => dpkg,
    source   => "/tmp/opencart.deb",
    require  => [Exec["has-opencart.deb"], Package["php5-mysql", "php5-gd", "php5-curl"], Package["php5"], Package["libapache2-mod-php5"]],
  
  }

  file {"/etc/apache2/sites-enabled/000-default":
    ensure  => absent, 
    require => Package["apache2"],
    notify  => Service["apache2"],
  }

  file {"/etc/apache2/sites-enabled/opencart":
    ensure  => link,
    target  => "/etc/apache2/sites-available/opencart",
    require => Package["opencart"],
    notify  => Service["apache2"],
  }
  file { "/var/opencart/config.php":
	content => template("web/config.php"),
	owner 	=> www-data,
	group	=> www-data,
	mode 	=> 440,
	require	=> Package["opencart"],	
  }

}