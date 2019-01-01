#
# Cookbook:: k8s-master
# Recipe:: provision
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'chef/provisioning'
require 'chef/provisioning/vagrant_driver'


vagrant_box 'ubuntu/xenial64' do
    url 'http://cloud-images.ubuntu.com/xenial/20181217/xenial-server-cloudimg-amd64-vagrant.box'
end

options = {
  vagrant_options: {
    'vm.box' => 'ubuntu/xenial64',
    'vm.hostname' => 'k8s-master',
    'vm.network' => [
      ':private_network, {ip: "192.168.56.3"}'
    ]
  },

  vagrant_config: <<-EOF
    config.vm.provider 'virtualbox' do |v|
      v.memory = 4096
      v.cpus = 4
    end
  EOF
}

machine 'k8s-master' do
  machine_options options
  role 'k8s-master'
  converge true
end