#!/bin/bash
kubectl create ns mssql
kubectl apply -n mssql -f pvc.yml
kubectl apply -n mssql -f secret.yml
kubectl apply -n mssql -f deployment.yml
kubectl apply -n mssql -f service.yml