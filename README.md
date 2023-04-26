# Setup
1. clone the repository `git clone https://github.com/shabbirsaifee92/multi-node-kind-cluster.git`
2. `cd multi-node-kind-cluster`

## multi-node-kind-cluster
Create a two node kind cluster with ingress controller

1. `./create_cluster.sh`

## istio-service-mesh
Install Istio service mesh without installing istio-gateway

1. [create a new cluster](#multi-node-kind-cluster)
1. execute `servicemesh/install_servicemesh.sh`

## complete-istio-setup
Install istio with all the components i.e service mesh and istio gateway

1. create a new cluster using `servicemesh/gateway/create_cluster.sh`
1. Install all istio components  `servicemesh/gateway/install_gateway.sh`

