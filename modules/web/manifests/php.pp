class php {

  package { ['php5','php5-mysql','php5-gd','php5-curl','libapache2-mod-php5']:
    ensure  => installed,
    require => Package["apache2"],
    notify  => Service["apache2"],  
  }
  
}