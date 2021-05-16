#!/bin/bash
kubectl create ns mongodb
kubectl apply -n mongodb -f pvc.yml
kubectl apply -n mongodb -f secret.yml
kubectl apply -n mongodb -f deployment.yml
kubectl apply -n mongodb -f service.yml
