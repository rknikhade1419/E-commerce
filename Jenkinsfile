pipeline {
    agent any
    
    environment {
        // Docker Hub Details
        DOCKER_HUB_CREDENTIALS = 'dockerhub-creds'
        DOCKER_HUB_USER = 'rknikhade1419'
        
        // Application Details
        APP_NAME = 'ecommerce-backend'
        IMAGE_NAME = "${DOCKER_HUB_USER}/${APP_NAME}"
        IMAGE_TAG = "${BUILD_NUMBER}"
        
        // Kubernetes Details (Renamed to k8s)
        K8S_NAMESPACE = 'ecommerce'
        K8S_DEPLOYMENT = 'backend'
        
        // Folder Paths from your project structure
        BACKEND_DIR = 'ecommerce-app/Backend'
        K8S_DIR = 'k8s'
    }
    
    tools {
        maven 'maven-3.8'
        jdk 'jdk-8'
    }
    
    stages {
        stage('Git Checkout') {
            steps {
                script { echo "STAGE 1: Checking out code" }
                git branch: 'main', url: 'https://github.com/rknikhade1419/E-commerce.git'
            }
        }
        
        stage('Maven Build') {
            steps {
                dir("${BACKEND_DIR}") {
                    sh 'mvn clean compile'
                }
            }
        }
        
        stage('Unit Tests') {
            steps {
                dir("${BACKEND_DIR}") {
                    sh 'mvn test'
                }
            }
            post {
                always { junit "${BACKEND_DIR}/target/surefire-reports/*.xml" }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                dir("${BACKEND_DIR}") {
                    withSonarQubeEnv('sonar-scanner') {
                        sh "mvn sonar:sonar -Dsonar.projectKey=${APP_NAME} -Dsonar.projectName=${APP_NAME}"
                    }
                }
            }
        }
        
        stage('OWASP Dependency Check') {
            steps {
                dir("${BACKEND_DIR}") {
                    dependencyCheck additionalArguments: "--scan ./ --format HTML --project ${APP_NAME}", odcInstallation: 'OWASP-DC'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
                }
            }
        }
        
        stage('Package Application') {
            steps {
                dir("${BACKEND_DIR}") {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                dir("${BACKEND_DIR}") {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Trivy Image Scan') {
            steps {
                sh "trivy image ${IMAGE_NAME}:${IMAGE_TAG} --format json --output trivy-report.json"
                sh "trivy image ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${IMAGE_NAME}:latest"
                    sh "docker logout"
                }
            }
        }
        
        stage('Deploy Database') {
            steps {
                withKubeConfig([credentialsId: 'k8s-config']) {
                    sh "kubectl create namespace ${K8S_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -"
                    // Now using the updated k8s directory path
                    sh "kubectl apply -f ${K8S_DIR}/mysql/"
                    sh "kubectl wait --for=condition=ready pod -l app=mysql -n ${K8S_NAMESPACE} --timeout=300s"
                }
            }
        }
        
        stage('Deploy Backend') {
            steps {
                withKubeConfig([credentialsId: 'k8s-config']) {
                    // Automatically updates the image in the deployment file within the k8s folder
                    sh "sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' ${K8S_DIR}/backend/backend-deployment.yaml"
                    sh "kubectl apply -f ${K8S_DIR}/backend/"
                    sh "kubectl wait --for=condition=ready pod -l app=backend -n ${K8S_NAMESPACE} --timeout=300s"
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                withKubeConfig([credentialsId: 'k8s-config']) {
                    sh "kubectl get pods -n ${K8S_NAMESPACE}"
                    sh "kubectl get svc -n ${K8S_NAMESPACE}"
                }
            }
        }
        
        stage('Health Check') {
            steps {
                withKubeConfig([credentialsId: 'k8s-config']) {
                    sh "kubectl run health-check-pod --image=curlimages/curl:latest --rm -i --restart=Never -n ${K8S_NAMESPACE} -- curl -s http://backend-service/actuator/health"
                }
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar, **/trivy-report.json', allowEmptyArchive: true
            cleanWs()
        }
    }
}