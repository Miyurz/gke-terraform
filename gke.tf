resource "google_container_cluster" "primary" {
  name               = "${var.k8s_cluster}"
	description = "Staging k8s cluster"
  project            = "${var.project}"
	zone               = "${var.k8s_cluster_zone}"
  /* Keep in mind this count is per zone, so the total # of nodes in the cluster = initial_node_count * number of zones*/
	initial_node_count = 1
  
	min_master_version = "${var.k8s_version}"
  node_version       = "${var.k8s_version}"

  additional_zones = [
    "us-central1-b",
    "us-central1-c",
  ]

  master_auth {
    username = "${var.master_auth_username}"
    password = "${var.master_auth_password}"
  }

  network    = "${google_compute_network.vpc-1.self_link}"
  subnetwork = "${google_compute_subnetwork.subnet-1.self_link}"
  
	node_config {
    machine_type     = "${var.k8s_node_machine_type}"
		disk_size_gb     = 20
		local_ssd_count  = 1
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels {
      test = "test_val"
    }
    tags = ["test1", "test2"]
  }
 
  /*
	https://cloud.google.com/kubernetes-engine/docs/how-to/pod-security-policies
	Keep in mind this is a beta feature from terraform
	*/
  #pod_security_policy_config {
	#   enabled = true
	#}


	addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
		network_policy_config {
	    disabled = false
		}
		kubernetes_dashboard {
		  disabled = true /* For security reasons.When we are sure we aren't leaking anything, we would wamnt to open it to our devs*/
		}
  }

}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}

