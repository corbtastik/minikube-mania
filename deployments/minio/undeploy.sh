#!/bin/bash
kubectl delete deployment minio-standalone -n minio
kubectl delete secret minio-admin-creds -n minio
kubectl delete services minio-standalone -n minio
kubectl delete pvc minio-pvc8gb -n minio