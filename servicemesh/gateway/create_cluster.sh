#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo -e "\n*******************************************************************************************************************"
echo -e "Installing Kind"
echo -e "*******************************************************************************************************************"
brew update && brew install kind

echo -e "\n*******************************************************************************************************************"
echo -e "Creating new kind cluster"
echo -e "*******************************************************************************************************************"
kind create cluster --config "$SCRIPT_DIR"/config-istio.yaml --name dev
