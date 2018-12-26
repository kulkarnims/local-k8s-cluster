#
# Cookbook:: k8s-master
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

vagrant_box 'ubuntu/xenial64' do
    url 'http://cloud-images.ubuntu.com/xenial/20181217/xenial-server-cloudimg-amd64-vagrant.box'
end