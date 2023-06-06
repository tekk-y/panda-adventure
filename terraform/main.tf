terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.51.0"
    }
  }
}

variable "project_id" {}
variable "service" {
  type = object({
    name     = string
    location = string
    image    = string
  })
}

resource "google_cloud_run_v2_service" "default" {
  project  = var.project_id
  name     = var.service.name
  location = var.service.location
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.service.image
    }
  }

  lifecycle {
    ignore_changes = [ template.containers.image ]
  }
}

resource "google_cloud_run_v2_service_iam_binding" "default" {
  project  = var.project_id
  name     = var.service.name
  location = var.service.location
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}
