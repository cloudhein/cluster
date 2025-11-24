# Flextrack Microservices Deployment with ArgoCD

This repository provides a Terraform-based infrastructure setup to deploy the `flextrack-app` microservices on a local Kubernetes cluster using ArgoCD for GitOps and the NGINX Ingress Controller for external access. The configuration automates the deployment of ArgoCD, the NGINX Ingress Controller, and the `flextrack-app` microservices, which include components such as `expenses-app`, `mailer-app`, `notifier-app`, `throttler-app`, `kafka-node`, `mongo-db`, `postgres-database`, `rabbitmq`, `redis`, and `zookeeper-node`.

# Flextrack Microservices Deployment Architecture Workflow

![alt text](./images/flextrack-microservices-v2.0.png)