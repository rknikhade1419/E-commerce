
# E-Commerce Multi-Tier Application - Complete DevSecOps Implementation

📋 **Table of Contents**

* [Project Overview](https://www.google.com/search?q=%23project-overview)
* [Architecture](https://www.google.com/search?q=%23architecture)
* [Tech Stack](https://www.google.com/search?q=%23tech-stack)
* [Features](https://www.google.com/search?q=%23features)
* [Prerequisites](https://www.google.com/search?q=%23prerequisites)
* [Quick Start](https://www.google.com/search?q=%23quick-start)
* [Detailed Setup Guide](https://www.google.com/search?q=%23detailed-setup-guide)
* [CI/CD Pipeline](https://www.google.com/search?q=%23cicd-pipeline)
* [Monitoring &amp; Logging](https://www.google.com/search?q=%23monitoring--logging)
* [Troubleshooting](https://www.google.com/search?q=%23troubleshooting)
* [Project Structure](https://www.google.com/search?q=%23project-structure)
* [API Documentation](https://www.google.com/search?q=%23api-documentation)
* [Contributing](https://www.google.com/search?q=%23contributing)
* [License](https://www.google.com/search?q=%23license)

---

## 🎯 Project Overview

A production-ready, cloud-native e-commerce application demonstrating DevSecOps best practices with complete CI/CD automation, monitoring, and logging capabilities. This project showcases enterprise-level deployment patterns using Kubernetes orchestration, automated security scanning, and comprehensive observability.

### Business Use Case

Multi-tier e-commerce platform with:

* Product catalog management
* User authentication & authorization
* Shopping cart functionality
* Order processing
* Real-time inventory tracking

---

## 🏗️ Architecture

### High-Level Architecture

**Code snippet**

```
graph TD
    Internet((Internet)) --> Ingress[Nginx Ingress Controller]
    Ingress -- SSL/TLS Termination --> Backend[Backend API Pods - 3 Replicas]
    Backend --> MySQL[(MySQL Database)]
    Backend --> Monitoring[Prometheus & Grafana]
    MySQL --> PV[Persistent Volume]
```

### CI/CD Pipeline Flow

**Code snippet**

```
graph LR
    GitHub -- Trigger --> Jenkins
    Jenkins --> Build
    Build --> Test
    Test --> Sonar[SonarQube Scan]
    Sonar --> OWASP[OWASP Scan]
    OWASP --> DockerBuild[Docker Build]
    DockerBuild --> Trivy[Trivy Image Scan]
    Trivy --> Push[Push to Docker Hub]
    Push --> Deploy[Deploy to K8s]
    Deploy --> Health[Health Check]
```

---

## 💻 Tech Stack

| **Layer**         | **Technology**        | **Purpose**     |
| ----------------------- | --------------------------- | --------------------- |
| **Backend**       | Java 8 / Spring Boot 2.7.18 | Application Framework |
| **Database**      | MySQL 8.0                   | Relational Database   |
| **Orchestration** | Kubernetes 1.28+            | Container Management  |
| **CI/CD**         | Jenkins 2.400+              | Automation Engine     |
| **Security**      | SonarQube, OWASP, Trivy     | Code & Image Scanning |
| **Observability** | Prometheus, Grafana, EFK    | Metrics & Logging     |

---

## 🚀 Quick Start

### 1. Clone Repository

**Bash**

```
git clone https://github.com/rknikhade1419/E-commerce.git
cd E-commerce
```

### 2. Local Development (Docker Compose)

**Bash**

```
# Start MySQL and Backend locally
docker-compose up -d

# Access application
curl http://localhost:8080/api/products
```

---

## 📖 Detailed Setup Guide

### Step 1: Build and Push Docker Image

**Bash**

```
cd backend
mvn clean package -DskipTests
docker build -t rknikhade1419/ecommerce-backend:1.0 .
docker login
docker push rknikhade1419/ecommerce-backend:1.0
```

### Step 2: Deploy Database

**Bash**

```
kubectl create namespace ecommerce

# Create Secret (Replace placeholders with your passwords)
kubectl create secret generic mysql-secret \
  --from-literal=root-password="REPLACE_WITH_YOUR_ROOT_PASS" \
  --from-literal=database=ecommerce \
  --from-literal=user=ecomuser \
  --from-literal=password="REPLACE_WITH_YOUR_APP_PASS" \
  -n ecommerce

kubectl apply -f k8s/mysql/
```

---

## 🔄 CI/CD Pipeline

Your Jenkins pipeline is configured with  **13 stages** .

### Jenkins Credentials Configuration

| **Credential ID** | **Type**    | **Value**     |
| ----------------------- | ----------------- | ------------------- |
| `dockerhub-creds`     | Username/Password | rknikhade1419       |
| `k8s-config`          | Secret File       | Your `kubeconfig` |
| `sonarqube-token`     | Secret Text       | Your Sonar token    |

---

## 🔧 Troubleshooting

* **CrashLoopBackOff:** Check if the MySQL pod is ready using `kubectl get pods -n ecommerce`.
* **ImagePullBackOff:** Verify the image `rknikhade1419/ecommerce-backend:1.0` exists on your Docker Hub.
* **503 Service Unavailable:** Check if the Nginx Ingress Controller is running in the `ingress-nginx` namespace.

---

## 📁 Project Structure

**Plaintext**

```
E-commerce/
├── backend/            # Spring Boot Source Code
├── k8s/                # Kubernetes Manifests
│   ├── mysql/          # DB Deployment
│   ├── backend/        # App Deployment
│   ├── monitoring/     # Prometheus & Grafana
│   └── logging/        # EFK Stack
├── Jenkinsfile         # Pipeline Definition
└── docker-compose.yml  # Local Setup
```

---

## 👨‍💻 Author

**Roshan Nikhade**

* **GitHub:** [@rknikhade1419](https://www.google.com/search?q=https://github.com/rknikhade1419)
* **LinkedIn:** [Roshan Nikhade](https://www.google.com/search?q=https://linkedin.com/in/roshan-nikhade-5b9577381)
* **Email:** nikhaderoshankumar@gmail.com

---

## 📄 License

This project is licensed under the MIT License.
