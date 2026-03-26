\# Docker Storage Migration on AWS EC2



This project demonstrates how to migrate Docker storage from a limited root volume (8GB) to a dedicated 20GB EBS volume.



\---



\# 🏗️ Architecture Overview



\## Before



\* Docker stored in `/var/lib/docker`

\* Root partition gets full ❌



\## After



\* Docker moved to `/dockerdata` (EBS volume)

\* Root partition freed ✅



\---



\# ⚙️ Tech Stack



\* AWS EC2

\* Linux (Ubuntu)

\* Docker \& Containerd

\* EBS Volumes

\* systemd



\---



\# 📌 Steps Performed



\## 1. Disk Setup



```bash

lsblk

sudo fdisk /dev/xvdf

"new" --> "p" --> "w"

sudo mkfs -t xfs /dev/xvdf1

```



\---



\## 2. Mount Volume



```bash

sudo mkdir /dockerdata

sudo mount /dev/xvdf1 /dockerdata

```



Persist:



```bash

echo '/dev/xvdf1 /dockerdata xfs defaults,nofail 0 2' | sudo tee -a /etc/fstab

```



\---



\## 3. Stop Docker (Important)



```bash

sudo systemctl stop docker.socket

sudo systemctl stop docker

sudo systemctl stop containerd

```



\---



\## 4. Configure Docker



`nano /etc/docker/daemon.json`



```json

{

 "data-root": "/dockerdata"

}

```



\---



\## 5. Migrate Containerd



```bash

sudo mkdir -p /dockerdata/containerd

sudo rsync -aqxP /var/lib/containerd/ /dockerdata/containerd/

sudo rm -rf /var/lib/containerd

sudo ln -s /dockerdata/containerd /var/lib/containerd

```



\---



\## 6. Fix Errors



\### Duplicate Config Issue



Removed `--data-root` from:



```

/usr/lib/systemd/system/docker.service

```



\---



\### Metadata Error Fix



```bash

sudo rm -rf /var/lib/containerd/io.containerd.metadata.v1.db

```



\---



\## 7. Restart Services



```bash

sudo systemctl daemon-reload

sudo systemctl start containerd

sudo systemctl start docker

```



\---



\## 8. Cleanup Old Data



```bash

sudo rm -rf /var/lib/docker/*

```



\---



\## 9. Verify



```bash

df -h

```



\---



\# 🧠 Key Learning



\## 🔥 Stop the Socket First



If `docker.socket` is not stopped:



\* Docker auto-restarts

\* Causes migration failure

\* Leads to "resource busy" errors



\---



\# 📊 Outcome



| Metric          | Before   | After              |

| --------------- | -------- | ------------------ |

| Root Disk Usage | ❌ Full   | ✅ Free             |

| Docker Storage  | ❌ Root   | ✅ Dedicated Volume |

| Stability       | ⚠️ Risky | ✅ Production Ready |



\---



\# 💡 Use Cases



\* Production Docker environments

\* CI/CD pipelines

\* Kubernetes worker nodes

\* AWS EC2 optimization



\---



\# 🏁 Conclusion
This project helps to demonstrate below DevOpsskills:



\* Storage management

\* Docker internals

\* Linux troubleshooting

\* AWS infrastructure handling





