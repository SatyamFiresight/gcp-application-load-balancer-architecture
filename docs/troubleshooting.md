# Troubleshooting Guide

This document lists common issues faced during the setup of the GCP Application Load Balancer and how to resolve them.

---

## ❌ Issue 1: VM Instances Not Accessible (HTTP not working)

### Symptoms:

* `curl http://<VM_IP>` fails
* Browser does not load page

### Cause:

Firewall rule not configured or incorrect target tags

### Solution:

Check firewall rules:

```bash
gcloud compute firewall-rules list
```

Verify instance tags:

```bash
gcloud compute instances describe www1
```

Create firewall rule if missing:

```bash
gcloud compute firewall-rules create allow-http \
  --allow tcp:80 \
  --target-tags=network-lb-tag
```

---

## ❌ Issue 2: Load Balancer Not Responding

### Symptoms:

* Cannot access Load Balancer IP
* Connection timeout

### Cause:

* Forwarding rule not created
* Incorrect IP reference

### Solution:

Check reserved IP:

```bash
gcloud compute addresses list
```

Check forwarding rules:

```bash
gcloud compute forwarding-rules list
```

Recreate if necessary.

---

## ❌ Issue 3: Backend Instances Showing UNHEALTHY

### Symptoms:

* Load balancer shows backend as unhealthy

### Cause:

* Health check failing
* Apache not running

### Solution:

Check Apache:

```bash
sudo systemctl status apache2
```

Restart Apache:

```bash
sudo systemctl restart apache2
```

Verify health checks:

```bash
gcloud compute health-checks list
```

---

## ❌ Issue 4: No Traffic Distribution

### Symptoms:

* Same server response every time

### Cause:

* Only one instance active
* Caching or session persistence

### Solution:

Check instances:

```bash
gcloud compute instances list
```

Test multiple times:

```bash
curl http://<LOAD_BALANCER_IP>
```

---

## ❌ Issue 5: Permission Denied (gcloud errors)

### Symptoms:

* Permission denied while running commands

### Cause:

* Not authenticated
* Wrong project selected

### Solution:

```bash
gcloud auth login
gcloud config set project <PROJECT_ID>
```

---

## ❌ Issue 6: Scripts Not Executing

### Symptoms:

* Permission denied when running scripts

### Solution:

```bash
chmod +x scripts/*.sh
```

---

## 💡 Debugging Tips

Check instance status:

```bash
gcloud compute instances list
```

Check logs:

```bash
journalctl -u apache2
```

Wait 2–5 minutes after load balancer setup for propagation.

---

## ✅ Best Practices Learned

* Always verify firewall rules
* Use health checks properly
* Validate each step before moving forward
* Do not assume resources are ready instantly
