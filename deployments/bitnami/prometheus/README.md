# Bitnami Prometheus

## Install

Watch the Prometheus Operator Deployment status using the command:

    kubectl get deploy -w --namespace monitoring -l app.kubernetes.io/name=kube-prometheus-operator,app.kubernetes.io/instance=prometheus-bitnami

Watch the Prometheus StatefulSet status using the command:

    kubectl get sts -w --namespace monitoring -l app.kubernetes.io/name=kube-prometheus-prometheus,app.kubernetes.io/instance=prometheus-bitnami

Prometheus can be accessed via port "9090" on the following DNS name from within your cluster:

    new-prometheus.monitoring.svc.cluster.local

To access Prometheus from outside the cluster execute the following commands:

    echo "Prometheus URL: http://127.0.0.1:9090/"
    kubectl port-forward --namespace monitoring svc/new-prometheus 9090:9090

Watch the Alertmanager StatefulSet status using the command:

    kubectl get sts -w --namespace monitoring -l app.kubernetes.io/name=kube-prometheus-alertmanager,app.kubernetes.io/instance=prometheus-bitnami

Alertmanager can be accessed via port "9093" on the following DNS name from within your cluster:

    new-alertmanager.monitoring.svc.cluster.local

To access Alertmanager from outside the cluster execute the following commands:

    echo "Alertmanager URL: http://127.0.0.1:9093/"
    kubectl port-forward --namespace monitoring svc/new-alertmanager 9093:9093