#!/bin/bash
kubectl delete deployment rabbitmq -n rabbitmq
kubectl delete services rabbitmq -n rabbitmq