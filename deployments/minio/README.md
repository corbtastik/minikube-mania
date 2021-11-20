# MinIO on dev K8s

[MinIO](https://min.io/) is object storage for on-prem and hybrid cloud environments and works great on Kubernetes.  In fact, they have a [Kubernetes Operator](https://github.com/minio/operator) to automate provisioning and management of object storage for multi-tenant environments.  If you're looking for an enterprise solution then definitely check out [their K8s work](https://docs.min.io/minio/k8s/).

This repo contains a simple, single node MinIO deployment useful for local development.  It does not use the before mentioned [Operator](https://github.com/minio/operator) or Helm Chart, rather just vanilla K8s descriptors, suitable for [Minikube](https://minikube.sigs.k8s.io/) or [K8s on Docker Desktop](https://docs.docker.com/desktop/kubernetes/).

> __Note:__ The deployment yaml does NOT use templates to inject variable values on `kubectl apply`, for example with `envsubst`, or [kustomize](https://kustomize.io/). Such tools and techniques are great but avoided here to keep things simple. Thus __before applying__ add values for the following...

* PersistentVolumeClaim `storageClassName`, commented out, thus will use "default", comment in to provide specific storage class.
* Secret username and password for MinIO admin user.

## Deploy

The `minio-all.yml` defines everything needed for a single node MinIO server. The following objects are created in K8s.


1. A `minio` namespace where everything is deployed.
2. An 8Gi [Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims), mounted to `/data` on the MinIO server.
3. A [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) for MinIO admin creds.
4. A [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) for the MinIO server including the admin console.
5. A [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service) targeting port `9000` on the MinIO deployment for server connectivity.
6. A [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service) targeting port `9001` on the MinIO deployment for admin console connectivity.
7. A [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) targeting port `9000` on the MinIO deployment for external server connectivity.
8. A [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) targeting port `9001` on the MinIO deployment for external admin console connectivity.

Both [Minikube](https://minikube.sigs.k8s.io/) and [K8s on Docker Desktop](https://docs.docker.com/desktop/kubernetes/) support hostpath Persistent Volume provisioning. You may need to edit `minio-all.yml` and specify the correct `storageClassName`. Docker Desktop's `storageClassName` is `hostpath`, where Minikube's is `standard`. The deployment yaml comments out `storageClassName` thus the cluster default Storage Class will be used, in most situations the default is set correctly by Minikube and Docker Desktop.

