# Bitnami Postgres

## Install

```bash
helm install postgres-bitnami -f values.yml --namespace postgres bitnami/postgresql
```

## Access

PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:

__Internal DNS__
```
postgres-bitnami-postgresql.postgres.svc.cluster.local - Read/Write connection
```

To get the password for "postgres" run:

```
export POSTGRES_ADMIN_PASSWORD=$(kubectl get secret --namespace postgres postgres-bitnami-postgresql -o jsonpath="{.data.postgresql-postgres-password}" | base64 --decode)
```

To get the password for "main_user" run:

```
export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-bitnami-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
```

To connect to your database run the following command:

```
kubectl run postgres-bitnami-postgresql-client --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:11.12.0-debian-10-r5 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgres-bitnami-postgresql -U main_user -d test -p 5432
```

To connect to your database from outside the cluster execute the following commands:

```
kubectl port-forward --namespace postgres svc/postgres-bitnami-postgresql 5432:5432 &
  PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432
```