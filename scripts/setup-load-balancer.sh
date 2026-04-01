#!/bin/bash

echo "Creating instance template..."

gcloud compute instance-templates create lb-backend-template \
  --region=us-central1 \
  --machine-type=e2-medium \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --tags=allow-health-check \
  --metadata=startup-script='#!/bin/bash
    apt-get update
    apt-get install apache2 -y
    systemctl start apache2
    HOSTNAME=$(hostname)
    echo "Served from: $HOSTNAME" > /var/www/html/index.html'

echo "Creating managed instance group..."

gcloud compute instance-groups managed create lb-backend-group \
  --template=lb-backend-template \
  --size=2 \
  --zone=us-central1-a

echo "Creating health check..."

gcloud compute health-checks create http http-basic-check \
  --port 80

echo "Creating backend service..."

gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --health-checks=http-basic-check \
  --global

echo "Adding backend to service..."

gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=us-central1-a \
  --global

echo "Creating URL map..."

gcloud compute url-maps create web-map-http \
  --default-service web-backend-service

echo "Creating HTTP proxy..."

gcloud compute target-http-proxies create http-lb-proxy \
  --url-map web-map-http

echo "Creating global IP..."

gcloud compute addresses create lb-ipv4-1 \
  --ip-version=IPV4 \
  --global

IP=$(gcloud compute addresses describe lb-ipv4-1 \
  --format="get(address)" \
  --global)

echo "Reserved IP: $IP"

echo "Creating forwarding rule..."

gcloud compute forwarding-rules create http-content-rule \
  --address=lb-ipv4-1 \
  --global \
  --target-http-proxy=http-lb-proxy \
  --ports=80

echo "Load Balancer setup complete."
echo "Access your app at: http://$IP"
