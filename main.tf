provider "google" {
  region = "us-west1"
}

resource "google_project" "external_load_balancer" {
  name            = "Google External Load Balancer"
  project_id      = "gc-external-load-balancer"
  billing_account = "01A1EA-D96462-0E3B12"
}

resource "google_compute_instance" "nginx_instance" {
  name         = "nginx-compute-instance"
  machine_type = "n1-standard-1"
  project      = "${google_project.external_load_balancer.project_id}"
  zone         = "us-west1-a"

  tags = ["nginx-compute-instance"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  // Local SSD disk
  scratch_disk {}

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    foo = "bar"
  }

  metadata_startup_script = "apt-get -qq install nginx"
}

resource "google_compute_firewall" "fw_instance_allow_ingress_80" {
  project = "${google_project.external_load_balancer.project_id}"
  name    = "fw-instance-ingress-80"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nginx-compute-instance"]
}

resource "google_compute_http_health_check" "nginx_http_health_check" {
  project      = "${google_project.external_load_balancer.project_id}"
  name         = "nginx-http-health-check"
  request_path = "/"
  port         = "80"
}

resource "google_compute_target_pool" "nginx_target_pool" {
  project   = "${google_project.external_load_balancer.project_id}"
  name      = "nginx-target-pool"
  region    = "us-west1"
  instances = ["us-west1-a/${google_compute_instance.nginx_instance.name}"]

  health_checks = [
    "${google_compute_http_health_check.nginx_http_health_check.name}",
  ]
}

resource "google_compute_forwarding_rule" "external_load_balancer" {
  project               = "${google_project.external_load_balancer.project_id}"
  name                  = "load-balancer-nginx"
  target                = "${google_compute_target_pool.nginx_target_pool.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
}
