#!/bin/bash
set -euo  pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

"$SCRIPT_DIR/../install_servicemesh.sh"

# Execute this script after install_servicemesh.sh
echo -e "\n*******************************************************************************************************************"
echo -e "Deploy istio gateway"
echo -e "*******************************************************************************************************************"
helm install istio-gateway istio/gateway -n istio-system

echo -e "\n*******************************************************************************************************************"
echo -e "Patching istio gateway service"
echo -e "*******************************************************************************************************************"
kubectl patch service istio-gateway -n istio-system --patch-file "$SCRIPT_DIR"/gateway-svc-patch.yaml

echo -e "\n*******************************************************************************************************************"
echo -e "Waiting for istiod to be ready"
echo -e "*******************************************************************************************************************"
kubectl wait pods --for=condition=Ready -l app=istiod -n istio-system --timeout=60s

echo -e "\n*******************************************************************************************************************"
echo -e "Deploying test applications"
echo -e "*******************************************************************************************************************"
kubectl apply -f "$SCRIPT_DIR/../../services.yaml" -n default

echo -e "\n*******************************************************************************************************************"
echo -e "Creating gateway resource and VirtualService for test applications"
echo -e -e "*******************************************************************************************************************"
kubectl apply -f "$SCRIPT_DIR/gateway.yaml" -n default

echo -e "\n*******************************************************************************************************************"
echo -e "Setup kiali"
echo -e "*******************************************************************************************************************"

"$SCRIPT_DIR/../../monitoring/install_monitoring.sh"
helm install kiali-server kiali-server --repo https://kiali.org/helm-charts --set auth.strategy="anonymous" --set external_services.prometheus.url="http://prometheus-server.monitoring" -n istio-system

echo -e "\n*******************************************************************************************************************"
echo -e "Setup Kiali access"
echo -e "*******************************************************************************************************************"
kubectl apply -f "$SCRIPT_DIR/kiali-vs.yaml" -n istio-system


echo -e "\n*******************************************************************************************************************"
echo -e "Waiting for kiali to be ready"
echo -e "*******************************************************************************************************************"
kubectl wait pods --for=condition=Ready -l app=kiali -n istio-system --timeout=60s

echo -e  "To access kiali open '127.0.0.1/kiali' in your browser"
