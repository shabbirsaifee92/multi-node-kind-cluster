#!/bin/bash
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

echo  "*******************************************************************************************************************"
echo  "Install grafana"
echo  "*******************************************************************************************************************"
helm install grafana grafana/grafana -n monitoring -f grafana-value.yaml

echo  "To access grafana run 'kubectl port-forward svc/grafana 8080:80 -n monitoring'"
