#!/bin/bash
DRIVER=$1
minikube start --driver $DRIVER --cpus 4 --memory 8192 --disk-size 40g
