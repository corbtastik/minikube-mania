# minio on minikube

[MinIO](https://min.io/) is object storage for on-prem and hybrid cloud environments and works great on Kubernetes.  In fact, they have a [Kubernetes Operator](https://github.com/minio/operator) that automates provisioning and management of object storage for multi-tenant environments.  If you're looking for an enterprise solution then definitely check out [their fine K8s work](https://docs.min.io/minio/k8s/).

This repo contains a simple, single node MinIO deployment useful for local development.  It does not use the before mentioned [Operator](https://github.com/minio/operator) or Helm Chart, rather just vanilla K8s descriptors, suitable for [minikube](https://minikube.sigs.k8s.io/).

The `deploy.sh` script creates the following objects in minikube.

1. A `minio` namespace where everything is deployed.
2. An 8Gi [persistent volume claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims), which is mounted to `/data` on the MinIO pod.
3. A [secret](https://kubernetes.io/docs/concepts/configuration/secret/) containing the MinIO admin creds.
4. A [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) containing a MinIO pod for the server and admin console.
5. A [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service) targeting port `9000` on the MinIO pod for server connectivity.
6. A [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service) targeting port `9001` on the MinIO pod for admin console connectivity.
7. A [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) targeting port `9000` on the MinIO pod for external server connectivity.
8. A [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) targeting port `9001` on the MinIO pod for external admin console connectivity.

All deployments in this repo leverage [minikube](https://minikube.sigs.k8s.io/) which comes with goodies to support dynamic persistence volumes and load-balancing.

* Persistent Volumes use [minikube's hostpath provisioner](https://minikube.sigs.k8s.io/docs/handbook/persistent_volumes/) which saves data to a location on the minikube instance.
* LoadBalancer support in minikube is an easy way to access services from `localhost`.  This requires running `minikube tunnel` to create network routes on the host to services in the cluster.  There are other ways to access apps but this is the easiest given we're running minikube with the docker driver on MacOS (or Windows) which has a few [networking limitations](https://docs.docker.com/desktop/mac/networking/#known-limitations-use-cases-and-workarounds) that render NodePorts useless.
