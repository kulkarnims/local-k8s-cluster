# Overview

This chef repository hosts the cookbooks to spin up local kubernetes cluster using vagrant and virtualbox
This local kubernetes cluster uses host-only network, contains single master and multiple worker nodes (default 2)

To provision a local kubernetes cluster:
./bin/provision-k8s-cluster.sh

To destroy the cluster:
./bin/destroy-k8s-cluster.sh
