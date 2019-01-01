#
# Cookbook:: k8s-worker
# Recipe:: provision
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'chef/provisioning'
require 'chef/provisioning/vagrant_driver'

vagrant_box 'ubuntu/xenial64' do
    url 'http://cloud-images.ubuntu.com/xenial/20181217/xenial-server-cloudimg-amd64-vagrant.box'
end

number_of_k8s_workers = 2

1.upto(number_of_k8s_workers) do |i|
  machine "k8s-worker-#{i}" do
    options = {
      vagrant_options: { 'vm.box' => 'ubuntu/xenial64',
       'vm.hostname' => "k8s-worker-#{i}",
       'vm.network' => [":private_network, {ip: \"192.168.56.#{i+3}\"}"]
      },
      vagrant_config: <<-EOF
        config.vm.provider 'virtualbox' do |v|
          v.memory = 2048
          v.cpus = 2
        end
      EOF
    }

    machine_options options
    role 'k8s-worker'
    converge true
  end
end