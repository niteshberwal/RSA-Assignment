AKS 3-Tier Application Deployment
This document provides a step-by-step guide for deploying a 3-tier application on Azure Kubernetes Service (AKS). The application includes a Frontend, Backend, and a Database. The infrastructure is managed using Terraform, and Helm is used for deploying and managing Kubernetes resources.

Prerequisites
Before starting, ensure you have the following tools installed and configured:

Azure Subscription: You should be the admin of an Azure subscription.
Docker Hub Account: Create a Docker Hub account to store your Docker images.
Terraform: Install Terraform to manage your infrastructure as code.
kubectl: Install kubectl to interact with your Kubernetes cluster.
Helm: Install Helm to manage Kubernetes applications.
To install these tools, follow the official documentation for each:

Terraform Installation
kubectl Installation
Helm Installation
Docker Installation
Azure CLI Installation
Steps to Deploy the Application
1. Build AKS Cluster using Terraform
Step 1: Clone the Repository and Navigate to the Terraform Directory
git clone <repo-url>
cd terraform/aks
Step 2: main.tf to define the AKS infrastructure
Step 3: Initialize and Apply the Terraform Configuration
Run the following commands to initialize Terraform and apply the configuration:

terraform init
terraform apply
This will create the resource group and the AKS cluster. The output will contain the kubeconfig to access the AKS cluster.

Step 4: Configure kubectl to Access AKS
Once the AKS cluster is created, configure kubectl to interact with it:
az aks get-credentials --resource-group aks-resource-group --name my-aks-cluster
kubectl get nodes

Ensure that you can access the cluster by checking the nodes.
2. Prepare Docker Images for the 3-Tier Application
You need to build Docker images for each component of the application (Frontend, Backend, Database).

Step 1: Dockerfile for Backend
Create a Dockerfile for the backend component (e.g., Node.js API).
# backend/Dockerfile
FROM node:16-alpine
WORKDIR /app
COPY . .
RUN npm install
CMD ["npm", "start"]

Step 2: Dockerfile for Frontend
Create a Dockerfile for the frontend component (e.g., React app).
# frontend/Dockerfile
FROM node:16-alpine
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
CMD ["npm", "start"]

Step 3: Dockerfile for Database (Optional for Local DB)
If you're using a custom database image, create a Dockerfile. Alternatively, you can use pre-built database images like MySQL or PostgreSQL from Docker Hub.
# database/Dockerfile (if you use a custom image)
FROM mysql:5.7
ENV MYSQL_ROOT_PASSWORD=rootpassword
Step 4: Build and Push Docker Images to Docker Hub
For each service (Frontend, Backend, Database), build and push the images to Docker Hub:

# Build the Docker images
docker build -t <your-dockerhub-username>/frontend:latest frontend/
docker build -t <your-dockerhub-username>/backend:latest backend/
docker build -t <your-dockerhub-username>/database:latest database/

# Push the images to Docker Hub
docker push <your-dockerhub-username>/frontend:latest
docker push <your-dockerhub-username>/backend:latest
docker push <your-dockerhub-username>/database:latest

3. Deploy the Application in AKS
Create Kubernetes manifests for the frontend, backend, and database services.

Step 1: Kubernetes Manifests for Deployments
YAML files for the deployments and services.
frontend-deployment.yaml
backend-deployment.yaml
database-deployment.yaml

Step 2: Kubernetes Services for Exposing Components
frontend-service.yaml
backend-service.yaml
database-service.yaml

Step 3: Apply Kubernetes Manifests
Deploy the application to your AKS cluster using kubectl:
kubectl apply -f frontend-deployment.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f database-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f database-service.yaml

4. Create Database for the Application
Option 1: Use Azure Database for MySQL/PostgreSQL
Create a MySQL or PostgreSQL instance in Azure and configure your backend to connect to the external database.

Option 2: Use a Local Database in AKS
You can use Helm to deploy a MySQL or PostgreSQL instance directly in AKS.
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-database bitnami/mysql

5. Verify the Deployment
Check the status of the pods and services:
kubectl get pods
kubectl get svc
