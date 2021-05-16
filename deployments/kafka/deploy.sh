#!/bin/bash
kubectl create ns kafka
kubectl apply -n kafka -f zk-deployment.yml
kubectl apply -n kafka -f zk-service.yml
kubectl apply -n kafka -f kafka-deployment.yml
kubectl apply -n kafka -f kafka-service.yml
