## Magic for forcing apt-get update to run before any package commands...
# This also where you'd configure the use of an apt cache
class apt-magic {
  file { "/etc/apt/apt.conf.d/15update-stamp":
	ensure => present,
	content => "APT::Update::Post-Invoke-Success {\"touch /var/lib/apt/periodic/update-success-stamp 2>/dev/null || true\";};",
  } 

  exec {"apt-get update":
	unless => "/usr/bin/test $(expr `date +%s` - `stat -c %Y /var/lib/apt/periodic/update-success-stamp`) -le 3600",
	command => "/usr/bin/apt-get update",
	require => File["/etc/apt/apt.conf.d/15update-stamp"]
  }
  Exec["apt-get update"] -> Package <||> 
  ## end of magic
}
