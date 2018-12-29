#
# Cookbook:: k8s-master
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'chef/provisioning'

machine 'k8s-master' do
  action :destroy
end