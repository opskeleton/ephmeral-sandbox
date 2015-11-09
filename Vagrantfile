# -*- mode: ruby -*-
# vi: set ft=ruby :

MIRROR=ENV['MIRROR'] || 'us.archive.ubuntu.com'

update = <<SCRIPT
if [ ! -f /tmp/up ]; then
  sudo sed -i.bak "s/us.archive.ubuntu.com/#{MIRROR}/g" /etc/apt/sources.list
  sudo sed -i.bak '/deb-src/d' /etc/apt/sources.list
  sudo aptitude update 
  touch /tmp/up
fi
SCRIPT



Vagrant.configure("2") do |config|

  bridge = ENV['VAGRANT_BRIDGE'] || 'eth0'
  env  = ENV['PUPPET_ENV'] || 'dev'

  config.vm.define :torguard do |node| 

    node.vm.provider 'virtualbox'
    node.vm.box = 'lubuntu-15.04_puppet-3.7.5'
    node.vm.hostname = 'torguard.local'
    # node.vm.network :public_network, :bridge => bridge, :dev => bridge
    node.ssh.port = 2222

    node.vm.provider :virtualbox do |vb|
	vb.memory = 6096
	vb.cpus = 4
	vb.gui = false
    end

    node.vm.provision :shell, :inline => update
    node.vm.provision :puppet do |puppet|
	puppet.manifests_path = 'manifests'
	puppet.manifest_file  = 'torguard.pp'
	puppet.options = "--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}"
    end
  end

  config.vm.define :ephmeral do |node| 

    node.vm.provider 'libvirt'
    node.vm.box = 'lubuntu-15.04_puppet-3.7.5'
    node.vm.network :public_network, :bridge => bridge, :dev => bridge

    node.vm.provider :libvirt do |domain,o|
	domain.uri = 'qemu+unix:///system'
	domain.host = 'ephmeral.local'
	domain.memory = 2048
	domain.cpus = 2
	o.vm.synced_folder './', '/vagrant', type: 'nfs'
    end

    node.vm.provision :shell, :inline => update
    node.vm.provision :puppet do |puppet|
	puppet.manifests_path = 'manifests'
	puppet.manifest_file  = 'ephmeral.pp'
	puppet.options = "--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}"
    end
  end
end
