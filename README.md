# minikube-mania

An exploration in using [minikube](https://minikube.sigs.k8s.io/) to host platforms for local development environments.

## DIY Deployments

* [Redis](/deployments/redis)
* [MongoDB](/deployments/mongodb)
* [Postgres](/deployments/postgres)
* [MS SQL Server](/deployments/mssql)
* [MinIO](/deployments/minio)
* [RabbitMQ](/deployments/rabbitmq)
* [Kafka](/deployments/kafka)
* [MySQL](/deployments/mysql)

## Bitnami Deployments

* [Bitnami Redis](/deployments/bitnami/redis)
* [Bitnami MinIO](/deployments/bitnami/minio)
* [Bitnami Kafka](/deployments/bitnami/kafka)

## Note on using Docker Desktop and minikube

[Minikube](https://minikube.sigs.k8s.io/) can be deployed as a standalone bare-metal process, as a VM or as a container by using the appropriate [driver](https://minikube.sigs.k8s.io/docs/drivers/).

The documentation and deployments in this repo assume minikube is running with the [docker driver](https://minikube.sigs.k8s.io/docs/drivers/docker/), and configured with 4 cpus, 8GB of memory and a 40GB disk.

In the spirit of transparency, I develop on a macOS machine but the deployments should work in Linux and Windows environments.  I mention because there's some [limitations on running Docker Desktop on macOS](https://docs.docker.com/desktop/mac/networking/#known-limitations-use-cases-and-workarounds) (and [Windows](https://docs.docker.com/desktop/windows/networking/#known-limitations-use-cases-and-workarounds)) that require workarounds, specifically with networking and accessing services in minikube.

## References

* [Minikube - docs](https://minikube.sigs.k8s.io/)
* [Minikube - drivers](https://minikube.sigs.k8s.io/docs/drivers/)
* [Minikube - accessing apps](https://minikube.sigs.k8s.io/docs/handbook/accessing/)
* [Docker Desktop for MacOS - networking](https://docs.docker.com/desktop/mac/networking/)
* [Bitnami Helm Charts](https://bitnami.com/stacks/helm)