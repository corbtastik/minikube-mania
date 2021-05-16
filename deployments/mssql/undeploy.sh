#!/bin/bash
kubectl delete deployment mssql -n mssql
kubectl delete secret mssql-admin-creds -n mssql
kubectl delete services mssql -n mssql
kubectl delete pvc mssql-pvc8gb -n mssql