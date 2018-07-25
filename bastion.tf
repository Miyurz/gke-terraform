resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["jump-server", "bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
		/*
		  Error creating network interfaces: exactly one of network or subnetwork must be provided
		*/
    #network = "default"
    subnetwork = "${google_compute_subnetwork.subnet-1.self_link}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata {
	  /*do not want the VM to get recreated when it changes */
    startup-script = "${file(var.startup_script)}"
    node = "bastion"
		sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

	/* If you want the VM to get recreated when it changes */
  #metadata_startup_script = "${file(var.startup_script)}"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

output "Bastion Internal IP" {
  value = "${google_compute_instance.bastion.network_interface.0.address}"
	description = "The internal ip address of the instance, either manually or dynamically assigned."
}

output "instance_id" {
  value       = "${google_compute_instance.bastion.name}"
  description = "The server-assigned unique identifier of this instance."
}

output "metadata_fingerprint" {
  value       = "${google_compute_instance.bastion.metadata_fingerprint}"
  description = "The unique fingerprint of the metadata."
}

output "self_link " {
  value       = "${google_compute_instance.bastion.self_link}"
  description = "The URL of the created instance"
}

output "Bastion External IP" {
  value       = "${google_compute_instance.bastion.network_interface.0.access_config.0.assigned_nat_ip}"
	description = "External IP of the bastion server"
} 
