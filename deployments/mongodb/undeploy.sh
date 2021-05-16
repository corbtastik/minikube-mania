#!/bin/bash
kubectl delete deployment mongodb-standalone -n mongodb
kubectl delete secret mongodb-admin-creds -n mongodb
kubectl delete services mongodb-standalone -n mongodb
kubectl delete pvc mongodb-pvc8gb -n mongodb