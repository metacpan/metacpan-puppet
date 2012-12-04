Vagrant::Config.run do |config|
  # download from http://vagrantbox.es (or build your own)
  config.vm.box = "squeeze64"

  # currently the puppet setup is designed to be bootstrapped
  # by these shell scripts rather than simply applied

  config.vm.provision :shell, :path => 'vagrant/provision.sh'

  # see "To Run" in README.md
end
