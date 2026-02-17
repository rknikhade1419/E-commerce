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

Security & Quality: SonarQube (Static Analysis), Trivy (Container Scanning)

Artifact Management: Sonatype Nexus

Orchestration: Kubernetes (kubectl, Helm)

Backend: Java 8, Spring Boot, Hibernate

Database: MySQL 8.0

Observability: Prometheus, Grafana (Monitoring), Elasticsearch, Fluentd, Kibana (Logging)


📁 Project Structure

**Plaintext**

```
E-commerce/
├── Docker/             # Docker configuration
├── ecommerce-app/      # Application Source
│   └── Backend/        # Spring Boot API
├── k8s/                # Kubernetes Manifests (Renamed from Kubernetes)
│   ├── backend/        # App Deployment
│   ├── logging/        # EFK Stack
│   ├── monitoring/     # Prometheus & Grafana
│   └── mysql/          # Database Deployment
└── Scripts/            # Automation & Utility Scripts
```

---


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
Install the monitoring stack using Helm and apply custom dashboards/alerts.

Bash
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
kubectl apply -f k8s/monitoring/
4. Execute CI/CD Pipeline
Connect your Jenkins instance to the Application Repository. The pipeline performs:

Unit Testing: Maven Test

Static Code Analysis: SonarQube Scan

Package: Maven Build (JAR)

Security: Trivy Image Scan

Push: Docker Hub Registry

Deploy: Kubernetes (EKS) Rolling Update

📊 Monitoring & Alerts
The platform includes custom Prometheus alerting rules for:

PodDown: Critical alert if an application pod fails.

HighResponseTime: Warning if p95 latency exceeds 2 seconds.

DatabaseConnectionLow: Critical alert if the backend loses DB connectivity.

🛡️ Security Best Practices (DevSecOps)
Multi-Stage Docker Builds: Minimizes the attack surface of the final image.

Non-Root Execution: Application runs as a restricted user within the container.

Secret Management: Sensitive DB credentials are never hardcoded; managed via K8s Secrets.

Init Containers: Ensures the application only starts when the database is verified as "Ready."



👨‍💻 Author

**Roshan Nikhade**

* **GitHub:** [@rknikhade1419](https://www.google.com/search?q=https://github.com/rknikhade1419)
* **LinkedIn:** [Roshan Nikhade](https://www.google.com/search?q=https://linkedin.com/in/roshan-nikhade-5b9577381)
* **Email:** nikhaderoshankumar@gmail.com

