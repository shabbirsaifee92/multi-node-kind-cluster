#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

clear

echo "*******************************************************************************************************************"
echo "Install Helm and add repos"
echo "*******************************************************************************************************************"
brew install helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

echo "*******************************************************************************************************************"
echo "Install prometheus"
echo "*******************************************************************************************************************"
helm install prometheus prometheus-community/prometheus -n monitoring --create-namespace

echo -e "\n*******************************************************************************************************************"
echo -e "Waiting for prometheus to be ready"
echo -e "*******************************************************************************************************************"
kubectl wait pods --for=condition=Ready -l app=prometheus -n monitoring --timeout=120s

echo  "*******************************************************************************************************************"
echo  "Install grafana"
echo  "*******************************************************************************************************************"
helm install grafana grafana/grafana -n monitoring -f "$SCRIPT_DIR"/grafana-value.yaml


echo -e "\n*******************************************************************************************************************"
echo -e "Waiting for grafana to be ready"
echo -e "*******************************************************************************************************************"
kubectl wait pods --for=condition=Ready -l app.kubernetes.io/instance=grafana -n monitoring --timeout=120s


echo  "To access grafana run 'kubectl port-forward svc/grafana 8080:80 -n monitoring'"
