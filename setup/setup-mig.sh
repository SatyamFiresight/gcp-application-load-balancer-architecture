#!/bin/bash

REGION="us-central1"
ZONE="us-central1-a"

# Create instance template
gcloud compute instance-templates create lb-template \
  --machine-type=e2-medium \
  --network=lb-network \
  --subnet=lb-subnet \
  --tags=http-server \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --metadata=startup-script='#! /bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    echo "<h1>Served from $(hostname)</h1>" > /var/www/html/index.html
  '

# Create Managed Instance Group
gcloud compute instance-groups managed create lb-group \
  --base-instance-name=lb-instance \
  --template=lb-template \
  --size=2 \
  --zone=$ZONE

# Set autoscaling (optional but strong for resume)
gcloud compute instance-groups managed set-autoscaling lb-group \
  --zone=$ZONE \
  --max-num-replicas=3 \
  --target-cpu-utilization=0.6 \
  --cool-down-period=60
