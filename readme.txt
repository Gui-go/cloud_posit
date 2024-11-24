
# GCP project config:
export BILLING_ACC="??????-??????-??????"
export PROJECT_NAME="cloud-posit"
export PROJECT_ID="${PROJECT_NAME}3"
gcloud projects create $PROJECT_ID --name=$PROJECT_NAME --labels=owner=guilhermeviegas,environment=dev --enable-cloud-apis
gcloud beta billing projects link $PROJECT_ID --billing-account=$BILLING_ACC
gcloud config set project $PROJECT_ID
gcloud projects list

# Git clone:
mkdir -p Documents/10-cloud-posit/
cd Documents/10-cloud-posit/
git clone git@github.com:Gui-go/cloud_posit.git

# Run Terraform:
cd cloud_posit/terraform
terraform init
terraform apply



# Build the image
sudo docker build -t personal_rstudio_img:v20241020 -f rstudio.Dockerfile .

# Check the images
sudo docker images

# Inspect the IMAGE ID of rstudio-custom:v20210526
docker inspect personal_rstudio_img:v20241020 --format '{{ .ID }}' | cut -f2- -d:
personal_rstudio_img_id=$(sudo docker inspect personal_rstudio_img:v20241020 --format '{{ .ID }}' | cut -f2- -d:)

# Turn it into a container
sudo docker run -d -e PASSWORD=minhasenha -p 8787:8787 -v $(pwd):/home/rstudio/my_data --name=personal_rstudio_ctn4 $personal_rstudio_img_id

# Check what's up
docker ps
