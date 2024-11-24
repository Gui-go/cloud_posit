
resource "google_compute_instance" "tf_computeinstance" {
  name         = "${var.proj_name}-computeinstance"
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240927"
      size  = 100  ################ var
      type  = "pd-ssd"
    }
  }
  network_interface {
    network = var.network_name
    access_config {}
  }
  scheduling {
    preemptible       = false
    automatic_restart = true
    on_host_maintenance = "TERMINATE"
  }
  metadata = {
    "user-data" = <<-EOF
      #!/bin/bash

      sudo apt update -y
      sudo apt install -y git
      
      sudo apt install tree -y 
      sudo apt install -y docker.io
      sudo systemctl start docker
      sudo systemctl enable docker
      sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose

      git clone https://github.com/Gui-go/cloud_posit.git /home/guilhermeviegas1993/cloud_posit/
      sudo env R_PASS=passwd123 docker-compose -f /home/guilhermeviegas1993/cloud_posit/docker/docker-compose.yml up -d --build
      sudo docker exec -t cloud_posit_container bash -c 'chown -R rstudio:rstudio /home/rstudio/volume/'
      sudo docker ps

      echo "VM init finished!"

    EOF    
  }
  service_account {
    email  = google_service_account.tf_computeinstance_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_service_account" "tf_computeinstance_service_account" {
  account_id   = "${var.proj_name}-serviceaccount"
  display_name = "Service account for VM to access GCS"
}

resource "google_project_iam_member" "tf_computeinstance_storage_access" {
  project = var.proj_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.tf_computeinstance_service_account.email}"
}



