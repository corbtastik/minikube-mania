#!/bin/bash
kubectl create ns mysql
kubectl apply -n mysql -f pvc-retro.yml
kubectl apply -n mysql -f secret.yml
kubectl apply -n mysql -f deployment.yml
kubectl apply -n mysql -f service.yml
