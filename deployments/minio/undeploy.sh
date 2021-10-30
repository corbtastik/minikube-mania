#!/bin/bash
kubectl delete deployment minio -n minio
kubectl delete secret minio-admin-creds -n minio
kubectl delete service minio-server-svc -n minio
kubectl delete service minio-console-svc -n minio
kubectl delete pvc minio-pvc -n minio
kubectl delete ns minio