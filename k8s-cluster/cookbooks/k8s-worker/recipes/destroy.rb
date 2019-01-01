#
# Cookbook:: k8s-master
# Recipe:: destroy
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'chef/provisioning'

number_of_k8s_workers = 3

1.upto(number_of_k8s_workers) do |i|
  machine "k8s-worker-#{i}" do
    action :destroy
  end
end