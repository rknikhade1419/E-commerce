pipeline {
    agent any
    
    environment {
        // Docker Hub Credentials
        DOCKER_HUB_CREDENTIALS = 'dockerhub-creds'
        DOCKER_HUB_USER = 'REPLACE_WITH_YOUR_DOCKERHUB_USERNAME'
        
        // Application Details
        APP_NAME = 'ecommerce-backend'
        IMAGE_NAME = "${DOCKER_HUB_USER}/${APP_NAME}"
        IMAGE_TAG = "${BUILD_NUMBER}"
        
        // Kubernetes Details
        K8S_NAMESPACE = 'ecommerce'
        K8S_DEPLOYMENT = 'backend'
        
        // Paths
        BACKEND_DIR = 'backend'
        K8S_DIR = 'k8s'
    }
    
    tools {
        maven 'maven-3.8'
        jdk 'jdk-8'
    }
    
    stages {
        
        stage('Git Checkout') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 1: Checking out code from Git"
                    echo "========================================="
                }
                
                git branch: 'main',
                    url: 'REPLACE_WITH_YOUR_GITHUB_REPO_URL'
                
                script {
                    echo "✓ Git checkout completed"
                    sh 'git log -1 --oneline'
                }
            }
        }
        
        stage('Maven Build') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 2: Building application with Maven"
                    echo "========================================="
                }
                
                dir("${BACKEND_DIR}") {
                    sh '''
                        echo "Maven version:"
                        mvn -v
                        
                        echo "Building backend application..."
                        mvn clean compile
                    '''
                }
                
                script {
                    echo "✓ Maven build completed"
                }
            }
        }
        
        stage('Unit Tests') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 3: Running Unit Tests"
                    echo "========================================="
                }
                
                dir("${BACKEND_DIR}") {
                    sh 'mvn test'
                }
                
                script {
                    echo "✓ Unit tests completed"
                }
            }
            
            post {
                always {
                    junit "${BACKEND_DIR}/target/surefire-reports/*.xml"
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 4: SonarQube Code Quality Analysis"
                    echo "========================================="
                }
                
                dir("${BACKEND_DIR}") {
                    withSonarQubeEnv('sonar-scanner') {
                        sh '''
                            mvn sonar:sonar \
                              -Dsonar.projectKey=ecommerce-backend \
                              -Dsonar.projectName=ecommerce-backend \
                              -Dsonar.java.binaries=target/classes
                        '''
                    }
                }
                
                script {
                    echo "✓ SonarQube analysis completed"
                }
            }
        }
        
        stage('OWASP Dependency Check') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 5: OWASP Security Vulnerability Scan"
                    echo "========================================="
                }
                
                dir("${BACKEND_DIR}") {
                    dependencyCheck additionalArguments: '''
                        --scan ./
                        --format HTML
                        --format XML
                        --project ecommerce-backend
                    ''', odcInstallation: 'OWASP-DC'
                    
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                }
                
                script {
                    echo "✓ OWASP scan completed"
                }
            }
        }
        
        stage('Package Application') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 6: Creating JAR package"
                    echo "========================================="
                }
                
                dir("${BACKEND_DIR}") {
                    sh 'mvn clean package -DskipTests'
                }
                
                script {
                    echo "✓ JAR package created"
                    sh "ls -lh ${BACKEND_DIR}/target/*.jar"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 7: Building Docker Image"
                    echo "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
                    echo "========================================="
                }
                
                dir("${BACKEND_DIR}") {
                    sh """
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                    """
                }
                
                script {
                    echo "✓ Docker image built successfully"
                    sh "docker images | grep ${APP_NAME}"
                }
            }
        }
        
        stage('Trivy Image Scan') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 8: Scanning Docker Image with Trivy"
                    echo "========================================="
                }
                
                sh """
                    trivy image ${IMAGE_NAME}:${IMAGE_TAG} \
                      --format json \
                      --output trivy-report.json
                    
                    trivy image ${IMAGE_NAME}:${IMAGE_TAG}
                """
                
                script {
                    echo "✓ Image security scan completed"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 9: Pushing Image to Docker Hub"
                    echo "========================================="
                }
                
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_HUB_CREDENTIALS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "Logging into Docker Hub..."
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        
                        echo "Pushing image with tag: ${IMAGE_TAG}"
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        
                        echo "Pushing image with tag: latest"
                        docker push ${IMAGE_NAME}:latest
                        
                        docker logout
                    """
                }
                
                script {
                    echo "✓ Image pushed to Docker Hub"
                    echo "  ${IMAGE_NAME}:${IMAGE_TAG}"
                    echo "  ${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Deploy Database') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 10: Deploying MySQL Database to K8s"
                    echo "========================================="
                }
                
                withKubeConfig([credentialsId: 'k8s-config']) {
                    sh """
                        kubectl create namespace ${K8S_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
                        
                        echo "Deploying MySQL Secret..."
                        kubectl apply -f ${K8S_DIR}/mysql/mysql-secret.yaml
                        
                        echo "Deploying MySQL ConfigMap..."
                        kubectl apply -f ${K8S_DIR}/mysql/mysql-configmap.yaml
                        
                        echo "Deploying MySQL PersistentVolume..."
                        kubectl apply -f ${K8S_DIR}/mysql/mysql-pv.yaml
                        
                        echo "Deploying MySQL PersistentVolumeClaim..."
                        kubectl apply -f ${K8S_DIR}/mysql/mysql-pvc.yaml
                        
                        echo "Deploying MySQL Deployment..."
                        kubectl apply -f ${K8S_DIR}/mysql/mysql-deployment.yaml
                        
                        echo "Deploying MySQL Service..."
                        kubectl apply -f ${K8S_DIR}/mysql/mysql-service.yaml
                        
                        echo "Waiting for MySQL to be ready..."
                        kubectl wait --for=condition=ready pod \
                          -l app=mysql \
                          -n ${K8S_NAMESPACE} \
                          --timeout=300s
                    """
                }
                
                script {
                    echo "✓ MySQL database deployed"
                }
            }
        }
        
        stage('Deploy Backend') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 11: Deploying Backend to K8s"
                    echo "========================================="
                }
                
                withKubeConfig([credentialsId: 'k8s-config']) {
                    sh """
                        sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' \
                          ${K8S_DIR}/backend/backend-deployment.yaml
                        
                        echo "Deploying Backend ConfigMap..."
                        kubectl apply -f ${K8S_DIR}/backend/backend-configmap.yaml
                        
                        echo "Deploying Backend Deployment..."
                        kubectl apply -f ${K8S_DIR}/backend/backend-deployment.yaml
                        
                        echo "Deploying Backend Service..."
                        kubectl apply -f ${K8S_DIR}/backend/backend-service.yaml
                        
                        echo "Waiting for backend to be ready..."
                        kubectl wait --for=condition=ready pod \
                          -l app=backend \
                          -n ${K8S_NAMESPACE} \
                          --timeout=300s
                    """
                }
                
                script {
                    echo "✓ Backend deployed"
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 12: Verifying Deployment"
                    echo "========================================="
                }
                
                withKubeConfig([credentialsId: 'k8s-config']) {
                    sh """
                        echo "=== PODS STATUS ==="
                        kubectl get pods -n ${K8S_NAMESPACE}
                        
                        echo ""
                        echo "=== SERVICES ==="
                        kubectl get svc -n ${K8S_NAMESPACE}
                        
                        echo ""
                        echo "=== DEPLOYMENTS ==="
                        kubectl get deployments -n ${K8S_NAMESPACE}
                        
                        echo ""
                        echo "=== BACKEND DEPLOYMENT DETAILS ==="
                        kubectl describe deployment ${K8S_DEPLOYMENT} -n ${K8S_NAMESPACE}
                        
                        echo ""
                        echo "=== RECENT EVENTS ==="
                        kubectl get events -n ${K8S_NAMESPACE} --sort-by='.lastTimestamp' | tail -20
                    """
                }
                
                script {
                    echo "✓ Deployment verification completed"
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    echo "========================================="
                    echo "STAGE 13: Application Health Check"
                    echo "========================================="
                }
                
                withKubeConfig([credentialsId: 'k8s-config']) {
                    sh """
                        SERVICE_IP=\$(kubectl get svc backend-service -n ${K8S_NAMESPACE} -o jsonpath='{.spec.clusterIP}')
                        echo "Backend Service IP: \$SERVICE_IP"
                        
                        kubectl run health-check-pod \
                          --image=curlimages/curl:latest \
                          --rm -i --restart=Never \
                          -n ${K8S_NAMESPACE} \
                          -- curl -s http://backend-service/actuator/health
                    """
                }
                
                script {
                    echo "✓ Health check passed"
                }
            }
        }
    }
    
    post {
        success {
            script {
                echo "========================================="
                echo "✓✓✓ PIPELINE COMPLETED SUCCESSFULLY ✓✓✓"
                echo "========================================="
                echo "Application deployed to namespace: ${K8S_NAMESPACE}"
                echo "Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                echo "========================================="
            }
        }
        
        failure {
            script {
                echo "========================================="
                echo "✗✗✗ PIPELINE FAILED ✗✗✗"
                echo "========================================="
                echo "Check logs for details"
                echo "Build number: ${BUILD_NUMBER}"
                echo "========================================="
            }
        }
        
        always {
            script {
                echo "Cleaning up workspace..."
            }
            
            sh """
                docker images | grep ${APP_NAME} | grep ${IMAGE_TAG} || true
            """
            
            archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
            archiveArtifacts artifacts: '**/trivy-report.json', allowEmptyArchive: true
        }
    }
}
