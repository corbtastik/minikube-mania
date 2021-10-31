#!/bin/bash
kubectl create ns minio
kubectl apply -f pvc.yml
kubectl apply -f secret.yml
kubectl apply -f deployment.yml
kubectl apply -f minio-service.yml
kubectl apply -f console-service.yml
kubectl apply -f minio-loadbalancer.yml
kubectl apply -f console-loadbalancer.yml
