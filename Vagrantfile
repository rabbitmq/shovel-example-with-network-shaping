# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.define "node1" do |node1|
    node1.vm.box = "ubuntu/trusty64"
    node1.vm.box_check_update = false
    node1.vm.network "private_network", ip: "192.168.33.11"
    node1.vm.hostname = "vm-node1"
    node1.vm.provider "virtualbox" do |v|
      v.memory = 1024
    end
  end
  config.vm.define "node2" do |node2|
    node2.vm.box = "ubuntu/trusty64"
    node2.vm.box_check_update = false
    node2.vm.network "private_network", ip: "192.168.33.12"
    node2.vm.hostname = "vm-node2"
    node2.vm.provider "virtualbox" do |v|
      v.memory = 1024
    end
  end

end
