#!/bin/bash
minikube start \
  --driver=docker \
  --nodes 4 \
  --cpus 4 \
  --memory 4g \
  --disk-size 64g \
  --mount-string="$HOME/vm-volumes/minikube-data:/data"
