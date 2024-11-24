
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

      echo "Personal RStudio repo -----------------------------------------------"
      sudo -u guilhermeviegas1993 git clone git@github.com:personalVM/personal_rstudio.git /home/guilhermeviegas1993/personal_rstudio/
      sudo git config --global --add safe.directory /home/guilhermeviegas1993/personal_rstudio
      sudo env R_PASS=passwd123 docker-compose -f /home/guilhermeviegas1993/personal_rstudio/docker-compose.yml up -d --build
      sudo docker exec -t personal_rstudio bash -c 'chown -R rstudio:rstudio /home/rstudio/volume/'
      sudo docker ps

      sudo docker exec -t personal_rstudio bash -c '
        sudo apt update -y
        sudo apt install tree -y
        sudo mkdir -p ~/.ssh
        sudo echo -e "${data.google_secret_manager_secret_version.tf_secretgitprivsshk.secret_data}" > ~/.ssh/id_rsa
        sudo chmod 600 ~/.ssh/id_rsa
        sudo touch ~/.ssh/known_hosts
        sudo ssh-keyscan -H github.com > ~/.ssh/known_hosts
        sudo chmod 600 ~/.ssh/known_hosts
        eval "$(ssh-agent -s)"
        sudo ssh-add ~/.ssh/id_rsa
        sudo git config --global user.email "guilhermeviegas1993@gmail.com"
        sudo git config --global user.name "Gui-go"
        sudo git config --global --add safe.directory /home/rstudio/volume/etl/
        sudo chmod -R 777 /home/rstudio/volume/etl/
      '

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



