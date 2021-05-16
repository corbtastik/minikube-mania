#!/bin/bash
kubectl create ns postgres
kubectl apply -n postgres -f pvc.yml
kubectl apply -n postgres -f secret.yml
kubectl apply -n postgres -f deployment.yml
kubectl apply -n postgres -f service.yml
