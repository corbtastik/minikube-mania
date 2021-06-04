#!/bin/bash
kubectl delete deployment mysql -n mysql
kubectl delete secret mysql-admin-creds -n mysql
kubectl delete services mysql -n mysql
kubectl delete pvc mysql-pvc8gb -n mysql
