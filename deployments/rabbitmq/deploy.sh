#!/bin/bash
kubectl create ns rabbitmq
kubectl apply -n rabbitmq -f deployment.yml
kubectl apply -n rabbitmq -f service.yml