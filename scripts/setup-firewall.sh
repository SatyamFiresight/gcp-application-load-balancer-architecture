#!/bin/bash

echo "Creating firewall rule for HTTP traffic..."

gcloud compute firewall-rules create allow-http \
  --network=default \
  --allow=tcp:80 \
  --target-tags=network-lb-tag \
  --description="Allow HTTP traffic to web servers"

echo "Firewall rule created."
