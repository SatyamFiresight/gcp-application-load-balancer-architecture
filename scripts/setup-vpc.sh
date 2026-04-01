#!/bin/bash

echo "Setting default region and zone..."

REGION="us-central1"
ZONE="us-central1-a"

gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

echo "Region and Zone configured:"
gcloud config list | grep compute
