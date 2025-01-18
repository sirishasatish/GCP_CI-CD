CI/CD Pipeline for a Java-Based API on Google Cloud

 This project sets up a CI/CD pipeline for a Java-based API application, deploying it to Google Cloud using Docker, Kubernetes, and Terraform. 

---

 Project Overview

This project demonstrates how to:
1. Set up a Google Cloud Platform (GCP) environment using Terraform.
2. Build and containerize a Java-based API application.
3. Deploy the containerized application to a Kubernetes cluster (GKE).
4. Use Cloud Storage for managing assets and firewall rules to secure traffic.

---

Prerequisites

Before diving in, make sure you have the following:
- Google Cloud Project: Ensure you have a GCP project with billing enabled.
- Terraform: Install Terraform
- Docker: Install Docker
- Google Cloud CLI: Install and authenticate the gcloud CLI
- kubectl: Install kubectl
---

Setup Instructions

1. Clone the Repository
Clone this repository to your local machine:
git clone https://github.com/sirishasatish/GCP_CI-CD

2. Initialize Terraform
Set up Terraform to provision the required resources
terraform init  
terraform validate 

3. Apply the Terraform Configuration
Provision your infrastructure on GCP:
terrafrom plan 
terrafrom apply (Review the plan before applying, types yes when prompted.)

4. Infrastructure Details
Once Terraform completes, here’s what gets created:
VPC and Subnet: A dedicated Virtual Private Cloud for the app.
Firewall Rules: Allows HTTP and HTTPS traffic to the cluster.
GKE Cluster: A Kubernetes cluster ready to host the application.
Cloud Storage Bucket: Stores assets (e.g., Terraform state).
Service Account: Manages roles and permissions for the cluster.

5. Build and Push Docker image 
i. Build the Docker Imge - Ensure the Java API code and DockerFile are ready
    docker build -t hello-world-api:v1
ii. Tag the Image to Aritfact Registry: 
    docker tag hello-world-api:v1 use-central1-docker.pkg.dev/gcp-ci-cd-project/ci-cd-repo/hello-world-api:v1
iii. Push the image to Artifact Registry
    docker push us-central1-docker.pkg.dev/gcp-ci-cd-project/ci-cd-repo/helloworldapi:v1
iv. Verify the Image in Artifact Registry: Go to the Artifact Registry in the GCP Console and confirm your image is available in the repository.

6. Deploy the Application on GKE
i. Connect to the Cluster: Authenticate and configure kubectl
   gcloud container clusters get-credentials ci-cd-cluster --zone us-central1-a --project gcp-ci-cd-project
ii. Create Kubernetes Manifests: Create deplyment.yaml to define your app's deployment.
iii. Apply the Manifests: Deploy your application
     kubectl apply -f deployment.yaml

7. Verify the Deployment: Check the running pods
    kubectl get pods

8. Get the external IP:
    kubectl get svc

9. Test the Application: Use the external IP from the previous step to test the API.
http: :8080
or curl http://34.70.157.57/hello

 




