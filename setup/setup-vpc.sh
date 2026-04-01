#!/bin/bash

PROJECT_ID=$(gcloud config get-value project)

echo "Using project: $PROJECT_ID"

gcloud compute networks create lb-network \
  --subnet-mode=custom

gcloud compute networks subnets create lb-subnet \
  --network=lb-network \
  --region=us-central1 \
  --range=10.0.0.0/24
