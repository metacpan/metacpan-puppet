Vagrant::Config.run do |config|
  # download from http://vagrantbox.es (or build your own)
  config.vm.box_url = "https://dl.dropbox.com/u/1543052/Boxes/DebianSqueeze64.box"

  config.vm.box = "squeeze64"

  # currently the puppet setup is designed to be bootstrapped
  # by these shell scripts rather than simply applied

  config.vm.provision :shell, :path => 'Vagrant/provision.sh'

  # see "To Run" in README.md

  config.vm.share_folder('v-puppet', '/etc/puppet', '.')
end
