#!/bin/bash
DRIVER=$1
minikube start \
  --profile minikube-$DRIVER \
  --driver $DRIVER \
  --cpus 4 \
  --memory 8192 \
  --disk-size 64g
