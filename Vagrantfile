# -*- mode: ruby -*-
# vi: set ft=ruby :
update = <<SCRIPT
if [ ! -f /tmp/up ]; then
  sudo aptitude update 
  touch /tmp/up
fi
SCRIPT


Vagrant.configure("2") do |config|

  config.vm.define :ephmeral do |node|
    bridge = ENV['VAGRANT_BRIDGE'] || 'eth0'

    env  = ENV['PUPPET_ENV'] || 'dev'

    node.vm.box = 'lubuntu-15.04_puppet-3.7.5' 
    node.vm.network :public_network, :bridge => bridge
    node.vm.hostname = 'ephmeral.local'
    node.ssh.port = 2222

    node.vm.provider :virtualbox do |vb|
      vb.memory = 4096
      vb.cpus = 4
      vb.gui = false
    end

    node.vm.provision :shell, :inline => update
    node.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
	puppet.manifest_file  = 'ephmeral.pp'
      puppet.options = "--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}"
    end
  end

end
