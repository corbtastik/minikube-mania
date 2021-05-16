#!/bin/bash
kubectl create ns redis
kubectl apply -n redis -f deployment.yml
kubectl apply -n redis -f service.yml