# Istio on dev K8s

```bash
curl -L https://istio.io/downloadIstio | sh -
cd istio*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
kubectl label namespace dev istio-injection=enabled
```

__Install bookinfo__

```bash
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
# check that app is working internally
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"

kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
istioctl analyze
```

__Minikube without LoadBalancer__

```bash
export MINIKUBE_PROFILE=dev1
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=$(minikube ip -p $MINIKUBE_PROFILE)
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
# print settings
echo "MINIKUBE_PROFILE=$MINIKUBE_PROFILE"
echo "INGRESS_HOST=$INGRESS_HOST"
echo "INGRESS_PORT=$INGRESS_PORT"
echo "SECURE_INGRESS_PORT=$SECURE_INGRESS_PORT"
echo "GATEWAY_URL=$GATEWAY_URL"

minikube tunnel -p $MINIKUBE_PROFILE
curl http://$GATEWAY_URL/productpage

```

__Minikube with a LoadBalancer__

```bash
kubectl get svc istio-ingressgateway -n istio-system
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
# print settings
echo "INGRESS_HOST=$INGRESS_HOST"
echo "INGRESS_PORT=$INGRESS_PORT"
echo "SECURE_INGRESS_PORT=$SECURE_INGRESS_PORT"
echo "GATEWAY_URL=$GATEWAY_URL"
```

__Install addons__

```bash
kubectl apply -f samples/addons
kubectl rollout status deployment/kiali -n istio-system
istioctl dashboard kiali
```

```bash
while true; do
    echo "call http://$GATEWAY_URL/productpage at `date`";
    curl -s -o /dev/null "http://$GATEWAY_URL/productpage";
    sleep 1;
done

# or
watch -n 1 curl -o /dev/null -s -w %{http_code} ${GATEWAY_URL}/productpage
```

## Uninstall

__Uninstall bookinfo__

```bash
samples/bookinfo/platform/kube/cleanup.sh
kubectl get virtualservices   #-- there should be no virtual services
kubectl get destinationrules  #-- there should be no destination rules
kubectl get gateway           #-- there should be no gateway
kubectl get pods              #-- the Bookinfo pods should be deleted
```

__Uninstall Istio__

```bash
kubectl delete -f samples/addons
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
istioctl tag remove default
kubectl delete namespace istio-system
kubectl label namespace default istio-injection-
```
