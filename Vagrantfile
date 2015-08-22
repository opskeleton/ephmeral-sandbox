# -*- mode: ruby -*-
# vi: set ft=ruby :
update = <<SCRIPT
if [ ! -f /tmp/up ]; then
  sudo aptitude update 
  touch /tmp/up
fi
SCRIPT


Vagrant.configure("2") do |config|

  Dir['manifests/*'].map{|it| it.match(/manifests\/(\w*).pp/)[1]}.each do |type|
    config.vm.define type.to_sym do |node| 

	bridge = ENV['VAGRANT_BRIDGE'] || 'eth0'
	env  = ENV['PUPPET_ENV'] || 'dev'

	node.vm.box = 'lubuntu-15.04_puppet-3.7.5'
	node.vm.hostname = "#{type}.local"
	node.vm.network :public_network, :bridge => bridge
      node.ssh.port = 2222

	node.vm.provider :virtualbox do |vb|
        vb.memory = 4096
        vb.cpus = 4
        vb.gui = false
	end

	node.vm.provider :libvirt do |domain|
	  domain.uri = 'qemu+unix:///system'
	  domain.host = "#{type}.local"
	  domain.memory = 2048
	  domain.cpus = 2
	end

	node.vm.provision :shell, :inline => update
	node.vm.provision :puppet do |puppet|
	  puppet.manifests_path = 'manifests'
	  puppet.manifest_file  = "#{type}.pp"
	  puppet.options = "--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}"
	end
    end
  end
end
