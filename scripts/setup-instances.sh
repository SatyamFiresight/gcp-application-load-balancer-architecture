#!/bin/bash

echo "Creating VM instances..."

for i in 1 2 3
do
  gcloud compute instances create www$i \
    --zone=us-central1-a \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script="#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      systemctl start apache2
      systemctl enable apache2
      echo '<h1>Web Server: www$i</h1>' > /var/www/html/index.html"
done

echo "Instances created."

echo "Listing instances:"
gcloud compute instances list
