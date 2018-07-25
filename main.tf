
// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}


terraform {
  backend "gcs" {
  }
}

/*
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
  version = "~> 1.0"
}
*/
