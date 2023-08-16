#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "\n*******************************************************************************************************************"
echo "Installing Kind"
echo "*******************************************************************************************************************"
brew update && brew install kind

echo "\n*******************************************************************************************************************"
echo "Creating new kind cluster"
echo "*******************************************************************************************************************"
kind create cluster --config "$SCRIPT_DIR"/config.yaml --name dev

echo "\n*******************************************************************************************************************"
echo "Installing Calico"
echo "*******************************************************************************************************************"
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml

echo "\n*******************************************************************************************************************"
echo "Installing Nginx Ingress Controller"
echo "*******************************************************************************************************************"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "\n*******************************************************************************************************************"
echo "Labeling work node"
echo "*******************************************************************************************************************"
kubectl label node dev-worker ingress-ready=true
