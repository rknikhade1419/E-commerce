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
* [Author](https://www.google.com/search?q=%23author)

---

## 🎯 Project Overview

A production-ready, cloud-native e-commerce application demonstrating **DevSecOps** best practices. This project includes automated CI/CD, security scanning, and comprehensive observability.

### Business Use Case

* Product catalog management
* User authentication & authorization
* Shopping cart and order processing

---

## 🏗️ Architecture

### High-Level Architecture

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
docker-compose up -d
curl http://localhost:8080/api/products
```

---

## 📖 Detailed Setup Guide

### Step 1: Build and Push Docker Image

**Bash**

```
# Move to the backend source directory
cd ecommerce-app/Backend
mvn clean package -DskipTests
docker build -t rknikhade1419/ecommerce-backend:1.0 .
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

# Apply manifests from the renamed k8s folder
kubectl apply -f k8s/mysql/
```

---

## 📁 Project Structure

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

## 👨‍💻 Author

**Roshan Nikhade**

* **GitHub:** [@rknikhade1419](https://www.google.com/search?q=https://github.com/rknikhade1419)
* **LinkedIn:** [Roshan Nikhade](https://www.google.com/search?q=https://linkedin.com/in/roshan-nikhade-5b9577381)
* **Email:** nikhaderoshankumar@gmail.com

---

## 📄 License

This project is licensed under the MIT License.
