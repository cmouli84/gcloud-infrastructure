provider "google" {
  region = "us-west1"
}

resource "google_project" "external_load_balancer" {
  name            = "Google External Load Balancer"
  project_id      = "external-load-balancer"
  billing_account = "01A1EA-D96462-0E3B12"
}

# resource "google_compute_instance" "lb_instance" {
#   name         = "external-load-balancer-compute-instance"
#   machine_type = "n1-standard-1"
#   project      = "${google_project.external_load_balancer.project_id}"
#   zone         = "us-west1-a"

#   tags = ["external-load-balancer-compute-instance"]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-8"
#     }
#   }

#   // Local SSD disk
#   scratch_disk {}

#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral IP
#     }
#   }

#   metadata {
#     foo = "bar"
#   }

#   metadata_startup_script = "apt-get -qq install nginx"
# }

# resource "google_compute_instance_group" "lb_instance_group" {
#   name        = "external-load-balancer-compute-instance_group"
#   description = "Instance group for LB"
#   project      = "${google_project.external_load_balancer.project_id}"

#   instances = [
#     "${google_compute_instance.lb_instance.self_link}"
#   ]

#   named_port {
#     name = "http"
#     port = "80"
#   }

#   zone = "us-west1-a"
# }

# resource "google_compute_instance_group" "lb_instance_group" {
#   name        = "external-load-balancer-compute-instance_group"
#   description = "Instance group for LB"
#   project      = "${google_project.external_load_balancer.project_id}"

#   instances = [
#     "${google_compute_instance.lb_instance.self_link}"
#   ]

#   named_port {
#     name = "http"
#     port = "80"
#   }

#   zone = "us-west1-a"
# }

