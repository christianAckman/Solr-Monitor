Vagrant.configure("2") do |config|


  config.vm.provider "virtualbox" do |v|
    v.name = "solr-vm"
    v.memory = 4096
    v.cpus = 4
  end

    # Choose distro
    config.vm.box = "ubuntu/xenial64"
    
    # Mount directory from host
    config.vm.synced_folder "app/", "/app"

    # Run provisioners
    config.vm.provision :shell, path: "setup.sh"

    # Create network
    config.vm.network "private_network", ip: "192.168.33.10"
    

end
