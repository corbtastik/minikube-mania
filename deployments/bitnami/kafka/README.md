# Bitnami Kafka

## Installing Kafka

```
helm install kafka-mini -f values --namespace kafka bitnami/kafka
```

## Accessing Kafka

Kafka can be accessed by consumers via port 9092 on the following DNS name from within your cluster:

```
kafka-mini.kafka.svc.cluster.local
```

Each Kafka broker can be accessed by producers via port 9092 on the following DNS name(s) from within your cluster:

```
kafka-mini-0.kafka-mini-headless.kafka.svc.cluster.local:9092
```

You need to configure your Kafka client to access using SASL authentication. To do so, you need to create the 'kafka_jaas.conf' and 'client.properties' configuration files with the content below:

```
- kafka_jaas.conf:
```

Where password is obtained from a secret.

```bash
kubectl get secret kafka-mini-jaas --namespace kafka \
    -o jsonpath='{.data.client-passwords}' | base64 --decode | cut -d , -f 1
```

```java
KafkaClient {
    org.apache.kafka.common.security.scram.ScramLoginModule required
    username="main_user"
    password="changeME123!";
};
```

```
- client.properties:
```
```
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-256
```

To create a pod that you can use as a Kafka client run the following commands.

```bash
# start client pod
kubectl run kafka-mini-client --restart='Never' \
  --image docker.io/bitnami/kafka:2.8.0-debian-10-r24 \
  --namespace kafka \
  --command -- sleep infinity

# configure client.properties
kubectl cp --namespace kafka ./client.properties \
  kafka-mini-client:/tmp/client.properties

# configure auth
kubectl cp --namespace kafka ./kafka_jaas.conf \
  kafka-mini-client:/tmp/kafka_jaas.conf
```

Run the following for the Producer and Consumer in a separate tab.

```bash
# export auth config as envar
kubectl exec --tty -i kafka-mini-client --namespace kafka -- bash
export KAFKA_OPTS="-Djava.security.auth.login.config=/tmp/kafka_jaas.conf"
```

__Producer:__

```bash
kafka-console-producer.sh \
    --producer.config /tmp/client.properties \
    --broker-list kafka-mini-0.kafka-mini-headless.kafka.svc.cluster.local:9092 \
    --topic test
```

__Consumer:__

```bash
kafka-console-consumer.sh \
    --consumer.config /tmp/client.properties \
    --bootstrap-server kafka-mini.kafka.svc.cluster.local:9092 \
    --topic test \
    --from-beginning
```

## References

1. [Container Image](https://hub.docker.com/r/bitnami/kafka)
1. [Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/kafka)