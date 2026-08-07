AWS EKS Creation and App Deployment with Terraform, Helm, Istio, Argo CD & Monitoring

> **Production-ready Kubernetes platform on Amazon EKS with Infrastructure as Code, GitOps, Service Mesh, Monitoring, and CI/CD automation.**

---

# Overview

This project provisions a **production-style Kubernetes platform** on **Amazon EKS** using **Terraform** and deploys the complete application platform using **Helm**.

## Platform Includes

* Amazon EKS Cluster
* AWS VPC Networking
* IAM Roles & Pod Identity
* AWS Load Balancer Controller
* Istio Service Mesh
* Prometheus & Grafana Monitoring
* Cluster Autoscaler
* Argo CD
* Sample Python Application
* Horizontal Pod Autoscaler (HPA)

---

# Architecture

```text
                               Internet
                                   │
                 ┌─────────────────┴─────────────────┐
                 │                                   │
         Application LoadBalancer          Monitoring LoadBalancer
                 │                                   │
         Istio Application Gateway       Istio Monitoring Gateway
                 │                                   │
          Hello World Application        Grafana & Prometheus
                         │
                  Amazon EKS Cluster
                         │
               Terraform Infrastructure
```

---

# Repository Structure

```text
.
├── app/                     # Sample Python application
├── agroCD/                  # ArgoCD bootstrap manifests
├── helm/
│   ├── agroCD/
│   ├── autoscaling/
│   ├── monitoring/
│   ├── networking/
│   └── service-mesh/
├── iam/                     # IAM policies
├── k8Deployfiles/
│   ├── helloWorld-helm/
│   └── namespace/
├── *.tf                     # Terraform infrastructure
└── README.md
```

---

# Features

* Infrastructure as Code using Terraform
* Production-ready Amazon EKS deployment
* Private worker nodes
* AWS Load Balancer Controller
* Istio Service Mesh
* Separate Application and Monitoring Ingress Gateways
* Prometheus monitoring
* Grafana dashboards
* Horizontal Pod Autoscaler
* Cluster Autoscaler
* Argo CD GitOps deployment
* Sample Python application deployment

---

# Prerequisites

Install the following tools before deployment.

| Tool      | Version                     |
| --------- | --------------------------- |
| AWS CLI   | v2+                         |
| Terraform | >= 1.6                      |
| kubectl   | Compatible with EKS Version |
| Helm      | v3+                         |
| eksctl    | Latest                      |
| Docker    | Latest                      |
| Git       | Latest                      |

---

# Deployment Workflow

This project uses **GitHub Actions** to automate infrastructure provisioning and application deployment.

## CI/CD Pipeline

When code is pushed to the repository:

1. GitHub Actions validates the Terraform configuration.
2. Terraform provisions or updates the AWS infrastructure.
3. Amazon EKS is created or updated.
4. Helm installs or upgrades:

   * AWS Load Balancer Controller
   * Istio Base
   * Istiod
   * Application Ingress Gateway
   * Monitoring Ingress Gateway
   * Prometheus & Grafana
   * Cluster Autoscaler
   * Argo CD
5. Argo CD YAML is configured with the Git repository path that contains the Kubernetes manifests.
6. Once Argo CD is deployed, it continuously synchronizes and deploys the application to the Kubernetes cluster.
7. Health checks verify the deployment.

---

# Self-Hosted GitHub Actions Runner

This project uses a **self-hosted GitHub Actions runner** running on an Amazon EC2 instance to automate infrastructure provisioning and Kubernetes deployments.

## Required Software

* Git
* AWS CLI v2
* Terraform (>= 1.6)
* kubectl
* Helm v3
* eksctl

## AWS Permissions

The runner must have AWS credentials (IAM Role or IAM User) with permissions to manage:

* Amazon EKS
* Amazon EC2
* Amazon VPC
* IAM
* Elastic Load Balancer
* Auto Scaling
* Amazon ECR
* Amazon S3

Configure:

* AWS CLI
* Docker User

---

# How It Works

> **Insert the architecture screenshot below**

```text
Screenshot:
docs/images/architecture.png
```

*(Replace with your GitHub image or local image path.)*

---

# CI/CD

Once the code is pushed to Git and committed to the **main** branch, GitHub Actions validates the code and proceeds further.

GitHub Actions are configured with the following workflows:

## Build Application

* Creates Docker image of the application.
* Pushes the Docker image to the repository.
* Whenever files under the **app** folder are modified or added, the workflow is triggered automatically.
* Builds and pushes the latest image to the Docker repository.

---

## Infra Deploy

The Infrastructure deployment has two phases.

### Infrastructure Creation

Creates the required AWS infrastructure:

* VPC
* Subnets
* Load Balancers
* EKS Cluster
* Node Groups
* IAM Resources

### Helm Add-ons

Installs production-ready Kubernetes components.

* AWS Load Balancer Controller
* Cluster Autoscaler
* Prometheus
* Grafana
* Argo CD
* Istio

Whenever Terraform files or Helm charts are modified, GitHub Actions compares the Terraform state stored in the S3 backend and applies only the required changes.

---

# GitOps

Argo CD is configured to regularly pull the configured Git branch and synchronize Kubernetes resources.

Whenever files inside the **k8Deployfiles** directory are modified:

* Argo CD detects the changes.
* Synchronizes the cluster automatically.
* Updates only the required resources.
* If resources are manually modified inside the cluster, Argo CD automatically reverts them back to the desired state stored in Git.

> **Git is the Single Source of Truth.**

---

# Platform Add-ons

## Cluster Autoscaler

Cluster Autoscaler automatically scales worker nodes.

Although Node Groups are configured, Kubernetes does not automatically increase or decrease worker nodes without a Cluster Autoscaler or Karpenter.

---

## AWS Load Balancer Controller

Creates AWS Load Balancers whenever Kubernetes Services of type **LoadBalancer** are created.

Without this controller, Kubernetes LoadBalancer Services remain in the **Pending** state.

---

## Prometheus

Acts as the central heart of the monitoring stack.

It automatically discovers Kubernetes targets and continuously collects metrics from applications and cluster components.

---

## Grafana

Prometheus stores metrics but is not intended for rich visualization.

Grafana transforms Prometheus metrics into dashboards for operational monitoring and analytics.

---

## Alertmanager

Prometheus detects alerts.

Alertmanager manages:

* Alert grouping
* Deduplication
* Notification routing
* Alert delivery

---

## Istio Ingress Gateway

Provides advanced traffic management capabilities including:

* Canary Releases
* A/B Testing
* Header-based Routing
* Traffic Splitting
* VirtualService based routing

---

# Access Services

| Service     | URL                                        |
| ----------- | ------------------------------------------ |
| Application | `http://<Application-LoadBalancer>/hello`  |
| Prometheus  | `http://<Monitoring-LoadBalancer>/`        |
| Grafana     | `http://<Monitoring-LoadBalancer>/grafana` |

---

# Monitoring & Observability

Monitoring stack includes:

* Prometheus
* Grafana
* Alertmanager

---

# Autoscaling

Implemented using:

* Horizontal Pod Autoscaler
* Kubernetes Metrics Server
* Cluster Autoscaler

---

# GitOps

Argo CD is included for GitOps deployments.

Deployment flow:

```text
Application
      │
      ▼
Git Repository
      │
      ▼
 Argo CD
      │
      ▼
 Kubernetes Cluster
```

---

# Advantages

## Infrastructure as Code

* Repeatable deployments
* Version-controlled infrastructure
* Easy disaster recovery

---

## Modular Helm Charts

* Independent platform components
* Easier upgrades
* Better maintainability

---

## Istio Service Mesh

* Advanced traffic routing
* Ingress management
* Observability
* Future-ready for mTLS and Canary deployments

---

## Separate Load Balancers

Application traffic and monitoring traffic are isolated.

### Benefits

* Improved security
* Independent scaling
* Reduced blast radius
* Easier operations

---

## Monitoring Stack

* Cluster health
* Application metrics
* Resource utilization
* Alerting

---

## Autoscaling

* Automatic Pod Scaling
* Automatic Node Scaling
* Cost Optimization

---

## GitOps

* Declarative deployments
* Automated synchronization
* Rollback support
* Auditability

---

## Limitations
- HTTPS/TLS is not configured; the platform currently uses HTTP.
- Domain names are not configured; AWS LoadBalancer DNS names are used.
- Secrets are managed through Kubernetes Secrets and can be replaced with AWS Secrets Manager or External Secrets Operator.

# Technologies Used

* Amazon EKS
* Terraform
* Helm
* Kubernetes
* Istio
* Argo CD
* Prometheus
* Grafana
* Cluster Autoscaler
* Docker
* Python

---
