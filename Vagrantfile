# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64-ubuntu-12.04LTS"
  config.vm.box_url = "http://192.168.1.145/vagrant/precise64_squishy_2013-02-09.box"
  # config.vm.box_url = "https://s3-us-west-2.amazonaws.com/squishy.vagrant-boxes/precise64_squishy_2013-02-09.box"
  # config.vm.box = "quantal64-cloudimage-12.10"
  # config.vm.box_url = "http://cloud-images.ubuntu.com/quantal/current/quantal-server-cloudimg-vagrant-amd64-disk1.box"

  config.vm.provider :virtualbox do |v|
    # Leverage this Host OS's resolve.  This includes /etc/hosts entries
    v.customize ["modifyvm", :id, "--natdnshostresolver1","on"]
    # Let's try 256MB of RAM.  ooh yeah.
    v.customize ["modifyvm", :id, "--memory",256]
  end

  config.vm.provider :aws do |aws|
    aws.access_key_id = "YOUR ACCESS KEY"
    aws.secret_access_key = "YOUR SECRET ACCESS KEY"
    aws.ssh_private_key_path = "#{ENV['HOME']}/.ec2/YOUR.PEM"
    aws.instance_type = "m1.small"
    aws.security_groups = "training"

    # ubuntu/images/ubuntu-precise-12.04-amd64-server-20130325
    aws.ssh_username = "ubuntu"

    ## Region us-west-1 AMI ami-f6c3eeb3
    # aws.region = "us-west-1"
    # aws.ami = "ami-f6c3eeb3"
    # aws.keypair_name = "training"

    # Region ap-northeast-1 AMI ami-bd1797bc (Tokyo)
    aws.region = "ap-northeast-1"
    aws.ami = "ami-bd1797bc"
    aws.keypair_name = "tokyo-training"

  end

  # 
  # If you're using Virtualbox munge your /etc/hosts to include
  # 172.16.1.10 web
  # 172.16.1.11 db
  # 172.16.1.2 monitor
  # 172.16.1.3 go
  #
  # If you're using AWS you'll need to replace the above IPs with the IPs dynamically assigned by AWS

  config.vm.define :db do |db|
      db.vm.network :private_network, ip: "172.16.1.11"
      db.vm.hostname = "db"
  

    db.vm.provision :puppet do |puppet|
      puppet.manifest_file = "db.pp"
      puppet.options="--verbose --debug"
      puppet.module_path = "modules"
    end 
  end

  config.vm.define :web do |web|
    web.vm.network :private_network, ip: "172.16.1.10"
    web.vm.hostname = "web"
    web.vm.provision :puppet do |puppet|
      puppet.manifest_file = "web.pp"
      puppet.options="--verbose --debug"
      puppet.module_path = "modules"
    end 
  end

  
  config.vm.define :monitor do |monitor|
    monitor.vm.network :private_network, ip: "172.16.1.2"
    monitor.vm.hostname="monitor"

    # This is a shell provisioner.  It sets up some basic prereqs for the course.
    monitor.vm.provision :shell, :path=> "setup_node.sh" do |s|
      s.args   = "'MonitorSG'"
    end
  end

  # I think only Go gets this...
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory",512]
  end

  config.vm.define :go do |go|
      go.vm.network :private_network, ip: "172.16.1.3"
      go.vm.hostname = "go"
      go.vm.provision :shell, :path=> "setup_node.sh" do |s|
        s.args   = "'GoServerSG'"
      end
  end

end
