Vagrant.configure("2") do |config|

  
  config.vm.define :packagist do |pg|

    config.vm.network "forwarded_port", guest: 80, host: 8081
 
    pg.vm.box = "precise64"
    pg.vm.box_url = "http://files.vagrantup.com/precise64.box"

    pg.vm.hostname = "packagist"

    pg.vm.provision :shell, :inline => "sudo apt-get update && sudo apt-get install puppet -y"
  
    pg.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "default.pp"
      puppet.module_path = ["modules"]
      puppet.options = ['--verbose']
    end

  end
end

