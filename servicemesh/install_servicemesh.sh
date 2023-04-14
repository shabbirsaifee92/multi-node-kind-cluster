brew install helm

helm repo add istio https://istio-release.storage.googleapis.com/charts

helm install istio-base istio/base -n istio-system --create-namespace

helm install istiod istio/istiod -n istio-system --wait

kubectl label ns default istio-injection=enabled --overwrite

kubectl apply -f services.yaml
