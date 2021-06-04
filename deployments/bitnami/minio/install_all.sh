#!/bin/bash
for i in {1..1}
do
   helm install minio1 --set service.loadBalancerIP=192.168.13.102 -f values.yml -n minio bitnami/minio
   helm install minio$i --set service.loadBalancerIP=192.168.13.$((100+$i)) -f values.yml -n minio bitnami/minio
#   helm uninstall minio$i -n minio
#  sleep 1
done
