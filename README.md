AWS EKS Platform Deployment with Terraform, Helm, Istio, Argo CD & Monitoring
Overview

This project provisions a production-style Kubernetes platform on Amazon EKS using Terraform and deploys the complete application platform using Helm.

The platform includes:
Amazon EKS Cluster
AWS VPC Networking
IAM Roles & Pod Identity
AWS Load Balancer Controller
Istio Service Mesh
Prometheus & Grafana Monitoring
Cluster Autoscaler
Argo CD
Sample Python Application
Horizontal Pod Autoscaler (HPA)
Architecture
Internet
    │
    ├───────────────┐
    │               │
Application LB   Monitoring LB
    │               │
App Gateway    Monitoring Gateway
    │               │
Hello App    Grafana / Prometheus
    │
Amazon EKS Cluster
    │
Terraform Infrastructure
Repository Structure
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

Features
Infrastructure as Code using Terraform
Production-ready Amazon EKS deployment
Private worker nodes
AWS Load Balancer Controller
Istio Service Mesh
Separate Application and Monitoring Ingress Gateways
Prometheus monitoring
Grafana dashboards
Horizontal Pod Autoscaler
Cluster Autoscaler
Argo CD GitOps deployment
Sample Python application deployment
Prerequisites

Install the following tools before deployment.

Tool	Version
AWS CLI	v2+
Terraform	>=1.6
kubectl	Compatible with EKS version
Helm	v3+
eksctl	Latest
Docker	Latest
Git	Latest

Deployment Workflow

This project uses GitHub Actions to automate infrastructure provisioning and application deployment.

CI/CD Pipeline

When code is pushed to the repository:

GitHub Actions validates the Terraform configuration.
Terraform provisions or updates the AWS infrastructure.
Amazon EKS is created or updated.
Helm installs or upgrades:
    AWS Load Balancer Controller
    Istio Base
    Istiod
    Application Ingress Gateway
    Monitoring Ingress Gateway
    Prometheus & Grafana
    Cluster Autoscaler
    Argo CD
AgroCD yaml with which file to targets the in git repo will be applied once.
Post the AgroCD deployes the App to K8 cluster.
Health checks verify the deployment.

This project uses a self-hosted GitHub Actions runner running on an Amazon EC2 instance to automate infrastructure provisioning and Kubernetes deployments

Required Software:
    Git
    AWS CLI v2
    Terraform (>= 1.6)
    kubectl
    Helm v3
    eksctl
    AWS Permissions

The runner must have AWS credentials (IAM Role or IAM User) with permissions to manage:
    Amazon EKS
    Amazon EC2
    Amazon VPC
    IAM
    Elastic Load Balancer
    Auto Scaling
    Amazon ECR
    S3 access
configure AWS and Docker user

How it works:
<img width="965" height="541" alt="Screenshot 2026-08-07 at 3 50 15 PM" src="https://github.com/user-attachments/assets/d76d8e83-d4b1-48ce-8ca6-f37d87304196" />

CI/CD: 

Once the code is Pushed to git and commited to main. Github actions validates and proceed further.

Github actions the configured as following:

Build Application:
Creates docker image of APP and pushes to repository.
When ever the files in app folder got modified or added. the the action triggers and build and pushes the latest image to docker repo.

Infra-deploy:
Infra deploy has two phases:
    Infra Creation: creates the require infra in AWS like VPC, LB, Nodes, etc.
    Helm Addons: Helm creates the cluster resources which are necessary for production like ALB, AutoScaler, prometheus, grafana and agroCD.
When ever the tf files changes tf files or files under helm folder are modified or created then this will create the run check the present from S3 bucket tf file and update and install the require helm files.

GitOps:
AgroCD is configured to regulary pull the branch and map the resources in cluster if any changes in K8Deploy files this will update the cluster. If any resources are created manually it will revert back to the git based resources. Here git acts as single source of trust.

What are all the Add-ons added to cluster and why?
Autoscaler is installed for auto scaling of nodes even though we have configered node groups cluster will not scale up or down automatically it need AWS autoscaler or karpenter to do this.
Aws-load-balancer-controller it is installed if any other service uses Load Balancer to spin LB configured in AWS. Without this if any LB based service is created will be in pending state.
Prometheus acts as the central heart of the monitoring stack. It discovers targets inside Kubernetes and pulls performance data from them.
Grafana, prometheus includes a basic user interface, but it is not built for daily analytics or executive reviews. Grafana steps in to translate raw numbers into actionable graphics
Alerting Manager for prometheus evaluates your data and triggers an alert if something goes wrong (e.g., a node runs out of memory). However, it doesn't know how to contact your team. It forwards those raw alerts to Alertmanager to manage the fallout.
Istio-ingress controller to manage complex routing rules like canary releases, A/B testing, header-based splits, and traffic shifting using VirtualService resources.

Access Services:
Application: http://<Application-LoadBalancer>/hello
Prometheus: http://<Monitoring-LoadBalancer>/
Grafana: http://<Monitoring-LoadBalancer>/grafana

Monitoring and observability by:
Prometheus
Grafana
Alertmanager

Autoscaling Implemented by following:
Horizontal Pod Autoscaler
Kubernetes Metrics Server
Cluster Autoscaler

GitOps:
Argo CD is included for GitOps deployments.
After installation:
Application → Git Repository → Argo CD → Kubernetes

Advantages
Infrastructure as Code
Repeatable deployments
Version-controlled infrastructure
Easy disaster recovery
Modular Helm Charts
Independent platform components
Easier upgrades
Better maintainability
Istio Service Mesh
Advanced traffic routing
Ingress management
Observability
Future-ready for mTLS and canary deployments
Separate Load Balancers

Application traffic and monitoring traffic are isolated.

Benefits:

Improved security
Independent scaling
Reduced blast radius
Easier operations
Monitoring Stack
Cluster health
Application metrics
Resource utilization
Alerting
Autoscaling
Automatic pod scaling
Automatic node scaling
Cost optimization
GitOps
Declarative deployments
Automated synchronization
Rollback support
Auditability

Technologies Used:
Amazon EKS
Terraform
Helm
Kubernetes
Istio
Argo CD
Prometheus
Grafana
Cluster Autoscaler
Docker
Python

