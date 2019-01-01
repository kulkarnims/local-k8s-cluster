#
# Cookbook:: k8s-worker
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

cookbook_file '/home/vagrant/k8s-worker-prereqs.sh' do
    source 'k8s-worker-prereqs.sh'
    owner 'vagrant'
    mode '0755'
end

execute 'k8s prerequisites' do
    cwd '/home/vagrant'
    command './k8s-worker-prereqs.sh'
end

execute 'add google repository' do
    command 'curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
end

package 'apt-transport-https'

file '/etc/apt/sources.list.d/kubernetes.list' do
    content 'deb http://apt.kubernetes.io/ kubernetes-xenial main'
end

apt_update 'update'

['docker.io', 'kubeadm', 'kubectl', 'kubelet', 'kubernetes-cni'].each do |p|
    package p
end

k8s_token_data_bag_item = data_bag_item('k8s', 'k8s-token')
k8s_join_token = k8s_token_data_bag_item['token']
k8s_ca_cert_hash = k8s_token_data_bag_item['ca-cert-hash']

execute 'join k8s cluster' do
    command "kubeadm join 192.168.56.3:6443 --token #{k8s_join_token} --discovery-token-ca-cert-hash sha256:#{k8s_ca_cert_hash} "
end