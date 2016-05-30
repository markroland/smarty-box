VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Set name of machine in VirtualBox
  config.vm.provider "virtualbox" do |v|
    v.name = "smarty_box"
    v.memory = 4096
  end

  # Set Virtual Box Operating System
  config.vm.box = "bento/centos-6.7"

  # Set hostname
  config.vm.hostname = "localhost"

  # Port forward Apache
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Set provisioning script
  config.vm.provision :shell, path: "config/provision.sh"

end
