# Specify the required Terraform version
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    random = { # Add the random provider
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.3.0"
}

# Configure the Google Cloud provider
provider "google" {
  project = "gcp-ci-cd-project" 
  region  = "us-central1"       
  zone    = "us-central1-a"     
}

# Create a Service Account for GKE
resource "google_service_account" "gke_service_account" {
  account_id   = "gke-service-account"
  display_name = "Service Account for GKE"
}

# Assign Roles to the Service Account
resource "google_project_iam_member" "gke_service_account_roles" {
  for_each = toset([
    "roles/container.admin",        
    "roles/compute.networkAdmin",  
    "roles/storage.admin",         
  ])

  project = "gcp-ci-cd-project"
  member  = "serviceAccount:${google_service_account.gke_service_account.email}"
  role    = each.value
}

# Create a Virtual Private Cloud (VPC)
resource "google_compute_network" "vpc_network" {
  name                    = "ci-cd-vpc"
  auto_create_subnetworks = false
}

# Create a Subnet within the VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "ci-cd-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

# Create Firewall Rules to Allow HTTP and HTTPS Traffic
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

# Create a Kubernetes Cluster (GKE)
resource "google_container_cluster" "primary" {
  name     = "ci-cd-cluster"
  location = "us-central1-a" # Change to a specific zone
  network  = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.subnet.id

  # Node pool configuration
  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-standard"
    disk_size_gb = 30
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  initial_node_count = 2
}

# Create a Cloud Storage Bucket
resource "google_storage_bucket" "ci_cd_bucket" {
  name          = "ci-cd-storage-bucket-${random_id.bucket_suffix.hex}" # Unique bucket name
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 # Deletes objects older than 30 days
    }
  }
}

# Random ID for unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

