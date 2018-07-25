resource "google_compute_network" "vpc-1" {
  name                    = "vpc-1"
  auto_create_subnetworks = "false"
	#ipv4_range              = "10.2.2.0/16"
	description             = "Staging VPC"
	project                 = "${var.project}"
}

resource "google_compute_subnetwork" "subnet-1" {
  name          = "subnet-1"
  ip_cidr_range = "10.0.0.0/16"
  region        = "${var.region}"
  network       = "${google_compute_network.vpc-1.self_link}"
}

resource "google_compute_address" "internal_with_subnet_and_address" {
  name         = "my-internal-address"
  subnetwork   = "${google_compute_subnetwork.subnet-1.self_link}"
  address_type = "INTERNAL"
  address      = "10.0.5.1" /* Reserve internal IP*/
  region       = "${var.region}"
}

