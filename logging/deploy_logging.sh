#!/bin/bash
clear 

echo "*******************************************************************************************************************"
echo "Install Helm"
echo "*******************************************************************************************************************"
brew install helm
helm repo add elastic https://helm.elastic.co

echo "*******************************************************************************************************************"
echo "Install Elastic Search"
echo "*******************************************************************************************************************"
helm install elasticsearch elastic/elasticsearch  --create-namespace -n logging -f es-values.yaml


echo  "*******************************************************************************************************************"
echo  "Waiting for elasticsearch to be ready"
echo  "*******************************************************************************************************************"

while [ "$(kubectl get pods -l=releasae='elasticsearch' -n logging -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; 
do
   sleep 5
   echo  "Waiting for the  elasticsearch to be ready"
done


echo "*******************************************************************************************************************"
echo "Install Kibana"
echo "*******************************************************************************************************************"
helm install kibana elastic/kibana -n logging -f kibana-values.yaml


echo  "*******************************************************************************************************************"
echo  "Waiting for kibana to be ready"
echo  "*******************************************************************************************************************"

while [ "$(kubectl get pods -l=release='kibana' -n logging -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; 
do
   sleep 5
   echo  "Waiting for kibana to be ready"
done

echo "*******************************************************************************************************************"
echo "Installing Filebeat log forwarder"
echo "*******************************************************************************************************************"
helm install filebeat elastic/filebeat -n logging

echo  "*******************************************************************************************************************"
echo  "Waiting for Filebeat to be ready"
echo  "*******************************************************************************************************************"

while [ "$(kubectl get pods -l=release='filebeat' -n logging -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; 
do
   sleep 5
   echo  "Waiting for Filebeat to be ready"
done

echo "run 'kubectl port-forward svc/kibana-kibana 5601 -n logging' to access kibana dashboard"
