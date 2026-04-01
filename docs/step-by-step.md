# Step-by-Step Implementation

## 1. Configure Environment
- Set default region and zone using gcloud

## 2. Create VM Instances
- 3 web servers (www1, www2, www3)
- Apache installed via startup script

## 3. Configure Firewall
- Allow HTTP (port 80)

## 4. Create Load Balancer
- Instance Template
- Managed Instance Group
- Health Check
- Backend Service
- URL Map
- Target HTTP Proxy
- Forwarding Rule

## 5. Testing
- Access Load Balancer IP
- Verify traffic distribution across instances
