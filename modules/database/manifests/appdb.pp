define opencart-data-setup($opencart_username,$opencart_password,$opencart_database) {
  exec { "create-opencart-database-${opencart_database}":
    unless  => "/usr/bin/mysqlshow -uroot ${opencart_database}", 
    command => "/usr/bin/mysqladmin -uroot create ${opencart_database}",
    require => Class["mysql"],
  }
  exec { "create-opencart-user-${opencart_database}-${opencart_username}":
    unless => "mysqlshow -u${opencart_username} -p${opencart_password} ${opencart_database}",
    command => "mysql -u root -e \"grant all on ${opencart_database}.* to '${opencart_username}'@'%' identified by '${opencart_password}'; grant all on ${opencart_database}.* to '${opencart_username}'@'localhost' identified by '${openpass_password}';\"",
    path => "/usr/bin",
    require => Exec["create-opencart-database-${opencart_database}"],
  }
  file { '/root/opencart.sql':
    content => template("database/opencart.sql"),
    require => Exec["create-opencart-user-${opencart_database}-${opencart_username}"],
  }
  
  exec {"load-opencart-schema":
    command     => "/usr/bin/mysql opencart < /root/opencart.sql",
    refreshonly => true,
    subscribe   => File['/root/opencart.sql'],
    require     => File["/root/opencart.sql"],
  }
}
