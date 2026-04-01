#!/bin/bash

gcloud compute firewall-rules create allow-http \
  --network=lb-network \
  --allow=tcp:80 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=http-server

gcloud compute firewall-rules create allow-health-check \
  --network=lb-network \
  --allow=tcp:80 \
  --source-ranges=130.211.0.0/22,35.191.0.0/16
