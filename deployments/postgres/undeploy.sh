#!/bin/bash
kubectl delete deployment postgres -n postgres
kubectl delete secret postgres-config -n postgres
kubectl delete services postgres -n postgres
kubectl delete pvc postgres-pvc8gb -n postgres