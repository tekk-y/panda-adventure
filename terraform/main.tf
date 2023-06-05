terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.51.0"
    }
  }
}

variable "service" {
  type = object({
    name     = string
    location = string
  })
}

resource "google_cloud_run_v2_service" "default" {
  name     = var.service.name
  location = var.service.location
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.service.image
    }
  }
}

resource "google_cloud_run_service_iam_binding" "default" {
  service  = var.service.name
  location = var.service.location
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}
