#
# Cookbook:: k8s-master
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

cookbook_file '/home/vagrant/k8s-master-prereqs.sh' do
    source 'k8s-master-prereqs.sh'
    owner 'vagrant'
    mode '0755'
end

execute 'k8s prerequisites' do
    cwd '/home/vagrant'
    command './k8s-master-prereqs.sh'
end

execute 'add google repository' do
    command 'curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
end

package 'apt-transport-https'

#apt_repository 'k8s repository' do
#    key 'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
#end

file '/etc/apt/sources.list.d/kubernetes.list' do
    content 'deb http://apt.kubernetes.io/ kubernetes-xenial main'
end

apt_update 'update'

['docker.io', 'kubeadm', 'kubectl', 'kubelet', 'kubernetes-cni'].each do |p|
    package p
end

k8s_token_data_bag_item = data_bag_item('k8s', 'k8s-token')
k8s_join_token = k8s_token_data_bag_item['token']

directory '/etc/kubernetes/pki' do
    owner 'root'
    group 'root'
    mode '0755'
end

cookbook_file '/etc/kubernetes/pki/ca.crt' do
    source 'ca.crt'
    owner 'root'
    group 'root'
    mode '0644'
end

cookbook_file '/etc/kubernetes/pki/ca.key' do
    source 'ca.key'
    owner 'root'
    group 'root'
    mode '0600'
end

execute 'initialize kubernetes' do
    command 'kubeadm init --apiserver-advertise-address=192.168.56.3 --pod-network-cidr=10.32.0.0/12'
end

execute 'create joining token' do
    command "kubeadm token create #{k8s_join_token}"
end

bash 'activate cluster' do
    code <<-EOH
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
    EOH
end

execute 'install pod network' do
    command 'kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d \'\n\')"'
end