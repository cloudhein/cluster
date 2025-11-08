# Flextrack Microservices Logging Infrastructure Deployment

This chart deploys a comprehensive logging and alerting infrastructure for Flextrack microservices on a local Kubernetes cluster:

- **Fluent Bit**: Lightweight logging agent deployed as DaemonSet to collect container logs from all worker nodes
- **Elasticsearch**: Distributed search and analytics engine for log storage, indexing, and querying
- **Kibana**: Web-based visualization platform for log exploration, dashboard creation, and data analysis
- **ElastAlert 2**: Alerting engine that monitors Elasticsearch using KQL queries and sends real-time Slack notifications when rule thresholds are exceeded

## Logging Infrastructure Architecture HLD for Flextrack Microservices

![alt text](./images/flextrack-logging-architecture.png)