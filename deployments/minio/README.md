# MinIO on dev K8s

[MinIO](https://min.io/) is object storage for on-prem and hybrid cloud environments and works great on Kubernetes.  In fact, they have a [Kubernetes Operator](https://github.com/minio/operator) to automate provisioning and management of object storage for multi-tenant environments.  If you're looking for an enterprise solution then definitely check out [their K8s work](https://docs.min.io/minio/k8s/).

This repo contains a simple, single node MinIO deployment useful for local development.  It does not use the before mentioned [Operator](https://github.com/minio/operator) or Helm Chart, rather just vanilla K8s descriptors, suitable for [Minikube](https://minikube.sigs.k8s.io/) or [K8s on Docker Desktop](https://docs.docker.com/desktop/kubernetes/).

> __Note:__ The deployment yaml does NOT use templates to inject variable values on `kubectl apply`, for example with `envsubst`, or [kustomize](https://kustomize.io/). Such tools and techniques are great but avoided here to keep things simple. Thus __before applying__ add values for the following...

* PersistentVolumeClaim `storageClassName`, commented out, thus will use "default", comment in to provide specific storage class.
* Secret username and password for MinIO admin user.

## Deploy

The `minio-all.yml` defines everything needed for a single node MinIO server. The following objects are created in K8s.

```bash
$ kubectl apply -f minio-all.yml
```

1. A `minio` namespace where everything is deployed.
2. An 8Gi [Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims), mounted to `/data` on the MinIO server.
3. A [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) for MinIO admin creds.
4. A [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) for the MinIO server including the admin console.
5. A [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service) targeting port `9000` on the MinIO deployment for server connectivity.
6. A [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service) targeting port `9001` on the MinIO deployment for admin console connectivity.
7. A [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) targeting port `9000` on the MinIO deployment for external server connectivity.
8. A [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) targeting port `9001` on the MinIO deployment for external admin console connectivity.

Both [Minikube](https://minikube.sigs.k8s.io/) and [K8s on Docker Desktop](https://docs.docker.com/desktop/kubernetes/) support hostpath Persistent Volume provisioning. You may need to edit `minio-all.yml` and specify the correct `storageClassName`. Docker Desktop's `storageClassName` is `hostpath`, where Minikube's is `standard`. The deployment yaml comments out `storageClassName` thus the cluster default Storage Class will be used, in most situations the default is set correctly by Minikube and Docker Desktop.

## Deploy MinIO Client

MinIO Client (aka mc) is a modern alternative to POSIX filesystem commands and admin tool for MinIO and Amazon S3 compatible services. The `minio-mc.yml` file contains definitions and config for an "mc" pod.

```bash
$ kubectl apply -f minio-mc.yml
```

When the pod starts it performs the following:

1. As an admin
    1. Sets up a connection for the minio_admin.
    1. Adds a non-admin user (minio_user), from data in the `minio-dev-creds` Secret.
    1. Adds a "developer" group.
    1. Sets `readwrite` and `diagnostics` permissions on the "developer" group.
1. As the minio_user
    1. Sets up a connection for the minio_user.
    1. Creates a bucket.
    1. Copies sample data into the bucket.
    1. Lists the bucket.

Once the pod is running you can `exec` into it and explore.

```bash
# from your dev machine
$ kubectl exec -i -t -n minio minio-mc -c minio-mc "--" sh -c "(bash || ash || sh)"
# in the "mc" container
[root@minio-mc /]$ mc ls minio/
[2021-12-04 21:09:58 UTC]     0B 20211204-1638652198/
[root@minio-mc /]$ mc ls minio/20211204-1638652198/
[2021-12-04 21:09:59 UTC]    13B howdy.txt
[2021-12-04 21:09:59 UTC] 1.5KiB mlb-parks.csv
[2021-12-04 21:09:59 UTC] 2.8KiB people.json
[root@minio-mc /]$ mc stat minio/20211204-1638652198/people.json
Name      : people.json
Date      : 2021-12-04 21:09:59 UTC 
Size      : 2.8 KiB 
ETag      : 19882c9b5d427aba0ce32cca17005359 
Type      : file 
Metadata  :
  Content-Type: application/json
```




## References

* [MinIO mc "new" docs](https://docs.min.io/minio/baremetal/reference/minio-cli/minio-mc.html)
* [MinIO mc "legacy" docs](https://docs.min.io/docs/minio-client-complete-guide.html)

