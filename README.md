🛒 E-Commerce DevSecOps Platform
This project is a production-grade, end-to-end DevSecOps implementation for a Java-based E-commerce platform. It leverages Infrastructure as Code (IaC), Automated CI/CD Pipelines, and a robust Observability Stack (Monitoring & Logging) deployed on Amazon EKS.

🏗️ Architecture Overview
The system is split into three distinct layers:

Tools Infrastructure: A dedicated EC2 environment running Jenkins, SonarQube, and Nexus.

Cloud Infrastructure: A highly available AWS EKS cluster with managed node groups across multiple AZs.

Application Layer: A Spring Boot microservice connected to a MySQL database, fully monitored via Prometheus, Grafana, and the EFK stack.

🛠️ Technology Stack
Cloud: AWS (EKS, EC2, VPC, IAM, EBS)

IaC: Terraform

CI/CD: Jenkins (Pipeline-as-Code)

Security & Quality: SonarQube, Trivy

Artifact Management: Sonatype Nexus

Orchestration: Kubernetes (kubectl, Helm)

Backend: Java 8, Spring Boot, Hibernate

Observability: Prometheus, Grafana, EFK Stack (Elasticsearch, Fluentd, Kibana)

📁 Project Structure
Plaintext
E-commerce/
├── Docker/             # Docker configuration (Local testing)
├── ecommerce-app/      # Application Source
│   └── Backend/        # Spring Boot API & Maven Config
├── k8s/                # Kubernetes Manifests
│   ├── backend/        # App Deployment & Service
│   ├── logging/        # EFK Stack (Elasticsearch, Fluentd, Kibana)
│   ├── monitoring/     # Prometheus & Grafana Configs
│   └── mysql/          # Database Deployment & PVC
└── Scripts/            # Automation & Utility Scripts
🚀 Deployment Steps
1. Provision the Tools Server
Navigate to the Tools directory and apply the Terraform configuration.

Bash
terraform init
terraform apply --auto-approve
2. Provision the EKS Cluster
Deploy the network and the Kubernetes cluster.

Bash
terraform init
terraform apply --auto-approve
aws eks update-kubeconfig --name ecommerce-cluster --region us-east-1
3. Setup Observability
Install the monitoring stack and apply custom dashboards/alerts.

Bash
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
kubectl apply -f k8s/monitoring/
🛡️ Security Best Practices (DevSecOps)
Multi-Stage Docker Builds: Minimizes the attack surface.

Secret Management: Sensitive DB credentials managed via K8s Secrets.

Init Containers: Ensures app only starts when DB is healthy.

👨‍💻 Author
Roshan Nikhade

GitHub: @rknikhade1419

LinkedIn: Roshan Nikhade

Email: nikhaderoshankumar@gmail.com
