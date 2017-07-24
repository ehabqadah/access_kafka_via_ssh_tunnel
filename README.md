# access_kafka_via_ssh_tunel
This is a shell script to access remote Kafka cluster via SSH tunnel.

# Usage:
`./kafkaTunnel.sh [--remote-machine user@hostname] [--zookeeper host1:port1, ...] [---bootstrap host1:port1, ...]`

* Then the Kafka zookeepers/servers can be accessed on the local machine by the original IPs/ports.

# Reference

This shell scrip is an extension for this [python script](https://github.com/simple-machines/kafka-tunnel_)
