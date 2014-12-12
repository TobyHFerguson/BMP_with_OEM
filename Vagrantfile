# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ol6minimal"
  config.vm.hostname = "oemrepo.lab.net"
  # config.ssh.username = "oracle"
  # config.ssh.forward_x11 = "true"
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.provision "shell", path: "setup.sh", privileged: false
end
