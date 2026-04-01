#!/bin/bash

ZONE="us-central1-a"

for i in 1 2 3
do
  gcloud compute instances create www$i \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "<h3>Web Server: www'$i'</h3>" > /var/www/html/index.html'
done

gcloud compute firewall-rules create allow-http \
  --allow tcp:80 \
  --target-tags network-lb-tag
