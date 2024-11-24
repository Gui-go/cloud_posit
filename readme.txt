









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
