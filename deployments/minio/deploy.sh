#!/bin/bash
kubectl create ns minio
kubectl apply -n minio -f pvc.yml
kubectl apply -n minio -f secret.yml
kubectl apply -n minio -f deployment.yml
kubectl apply -n minio -f service.yml
