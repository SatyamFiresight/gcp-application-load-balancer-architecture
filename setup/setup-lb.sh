#!/bin/bash

ZONE="us-central1-a"

# Health check
gcloud compute health-checks create http http-basic-check \
  --port 80

# Backend service
gcloud compute backend-services create web-backend \
  --protocol=HTTP \
  --health-checks=http-basic-check \
  --global

# Add MIG to backend
gcloud compute backend-services add-backend web-backend \
  --instance-group=lb-group \
  --instance-group-zone=$ZONE \
  --global

# URL map
gcloud compute url-maps create web-map \
  --default-service web-backend

# Target proxy
gcloud compute target-http-proxies create http-proxy \
  --url-map web-map

# Forwarding rule (this gives external IP)
gcloud compute forwarding-rules create http-rule \
  --global \
  --target-http-proxy=http-proxy \
  --ports=80
