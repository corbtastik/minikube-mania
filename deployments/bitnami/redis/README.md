# Bitnami Redis

## Installing Redis

```
helm install redis-mini -f values.yml --namespace redis bitnami/redis
```

## Accessing Redis

Redis(TM) can be accessed via port 6379 on the following DNS name from within your cluster:

```
redis-mini-master.redis.svc.cluster.local
```

To get your password run:

```
export REDIS_PASSWORD=$(kubectl get secret --namespace redis redis-mini -o jsonpath="{.data.redis-password}" | base64 --decode)
```

To connect to your Redis(TM) server:

1. Run a Redis(TM) pod that you can use as a client:

```
kubectl run --namespace redis redis-client \
    --restart='Never' \
    --env REDIS_PASSWORD=$REDIS_PASSWORD \
    --image docker.io/bitnami/redis:6.2.3-debian-10-r15 \
    --command -- sleep infinity
```

Use the following command to attach to the pod:

```
kubectl exec --tty -i redis-client --namespace redis -- bash
```

2. Connect using the Redis(TM) CLI:

```
redis-cli -h redis-mini-master -a $REDIS_PASSWORD
```

To connect to your database from outside the cluster execute the following commands:

```
kubectl port-forward --namespace redis svc/redis-mini-master 6379:6379 &
redis-cli -h 127.0.0.1 -p 6379 -a $REDIS_PASSWORD
```