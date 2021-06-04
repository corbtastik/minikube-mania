# Bitnami MinIO

## Installing

```
helm install minio-bitnami -f values.yml --namespace minio bitnami/minio
```

## Accessing within minikube

MinIO(R) can be accessed via port 9000 on the following DNS name from within your cluster:

```
mini-minio.minio.svc.cluster.local
```

To get your credentials run:

```
export ACCESS_KEY=$(kubectl get secret --namespace minio mini-minio -o jsonpath="{.data.access-key}" | base64 --decode)
export SECRET_KEY=$(kubectl get secret --namespace minio mini-minio -o jsonpath="{.data.secret-key}" | base64 --decode)
```

## Connect with a client

To connect to your MinIO(R) server using a client:

- Run a MinIO(R) Client pod and append the desired command (e.g. 'admin info'):

```
kubectl run --namespace minio mini-minio-client \
   --rm --tty -i --restart='Never' \
   --env MINIO_SERVER_ACCESS_KEY=$ACCESS_KEY \
   --env MINIO_SERVER_SECRET_KEY=$SECRET_KEY \
   --env MINIO_SERVER_HOST=mini-minio \
   --image docker.io/bitnami/minio-client:2021.5.18-debian-10-r3 -- admin info minio
```

To access the MinIO(R) web UI:

- Get the MinIO(R) URL:

```
echo "MinIO(R) web URL: http://127.0.0.1:9000/minio"
kubectl port-forward --namespace minio svc/mini-minio 9000:9000
```

# References

* [MinIO Client Container](https://github.com/bitnami/bitnami-docker-minio-client)