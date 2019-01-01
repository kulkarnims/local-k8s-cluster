#!/usr/bin/env bash

export CHEF_DRIVER=vagrant
export VAGRANT_DEFAULT_PROVIDER=virtualbox

#destroy
chef-client --local-mode --listen --runlist 'recipe[k8s-worker::destroy]'