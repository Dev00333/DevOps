# 🚀 DevOps Journey — Devang Mishra

> A hands-on DevOps learning repository documenting my journey through Infrastructure as Code, Cloud Provisioning, and Container Orchestration.

---

## 📁 Repository Structure

```
DevOps/
├── TERRAFORM/
│   ├── tf-simple-ec2/          # First EC2 setup with multi-instance provisioning
│   ├── practice-ec2/           # EC2 with Nginx + Docker bootstrapping
│   ├── testing/                # EC2 with auto-deployed BMI Calculator app
│   ├── knowledge_refresh/      # Full VPC + public/private EC2 setup (eu-north-1)
│   └── remote-infra/           # S3 + DynamoDB for Terraform remote state backend
│
├── KUBERNETES/
│   └── LondeShubham/
│       ├── first.yaml          # KinD cluster config (1 control-plane + 2 workers)
│       ├── setup.sh            # Automated cluster setup & app deployment script
│       └── Nginx/
│           ├── namespace.yaml  # Dedicated nginx namespace
│           ├── deployment.yaml # Nginx Deployment (2 replicas) with PVC
│           ├── service.yaml    # ClusterIP service on port 80
│           ├── pv.yaml         # 1Gi PersistentVolume (hostPath)
│           ├── pvc.yaml        # PersistentVolumeClaim bound to PV
│           ├── daemon.yaml     # DaemonSet — 1 Nginx pod per node
│           ├── Job.yaml        # One-time batch Job using busybox
│           └── cronjob.yaml    # CronJob for scheduled backup simulation
│
└── ec2_instance_for_testing_all/
    ├── ec2_all.tf              # All-in-one EC2 with ports 22/80/443/8080/ICMP
    └── user_data.sh            # Bootstraps Docker, KinD, kubectl, clones this repo
```

---

## ☁️ Terraform Projects

### `tf-simple-ec2`
The starting point. Provisions an EC2 instance using:
- Key pair, security group (SSH/HTTP/HTTPS), and default VPC
- `for_each` to spin up **three instance types** simultaneously: `t3.micro`, `t3.small`, `c7i-flex.large`
- Conditional storage sizing based on environment (`prd` gets 10GB, others use default)
- User data installs Nginx, Docker, and Docker Compose

### `practice-ec2`
A more refined EC2 setup that adds:
- ICMP (ping) ingress rule for connectivity testing
- User data that installs Docker, Docker Compose, and builds **Nginx from source** (`nginx-1.29.7`)
- Variables for AMI, instance type, and storage type/size

### `testing`
EC2 configured to automatically deploy a real app on boot:
- Opens port **3000** in addition to standard SSH/HTTP/HTTPS
- User data script clones the [BMI Calculator](https://github.com/Dev00333/bmi-calculator) repo and runs it via `docker compose up -d`
- Full logging to `/var/log/user-data.log` with non-interactive apt configuration

### `knowledge_refresh`
The most advanced Terraform project — a full multi-subnet VPC setup in **eu-north-1**:
- Uses the `terraform-aws-modules/vpc/aws` module with a `10.0.0.0/16` CIDR
- **3 public subnets** + **3 private subnets** across 3 AZs (`eu-north-1a/b/c`)
- NAT Gateway + VPN Gateway enabled
- Deploys **3 public EC2 instances** and **3 private EC2 instances** using `for_each`
- Separate key pairs and security groups for public vs private instances
- Private instances only accept SSH from within the VPC CIDR ranges

### `remote-infra`
Sets up the infrastructure for **Terraform remote state management**:
- **S3 bucket** (`my-remote-s3-bucket-devang`) to store the `.tfstate` file
- **DynamoDB table** (`my_dynamodb_table`) with `LockID` hash key for state locking
- Prevents concurrent `terraform apply` conflicts in team environments

---

## ☸️ Kubernetes Projects

### KinD Cluster (`LondeShubham/`)

A local Kubernetes setup using [KinD](https://kind.sigs.k8s.io/) (Kubernetes in Docker):

**Cluster Config (`first.yaml`)**
- 1 control-plane node + 2 worker nodes running `kindest/node:v1.32.0`
- Port mappings on the worker: `80` and `443` exposed to the host

**Nginx App Stack**

| Resource | Details |
|----------|---------|
| Namespace | `nginx` — isolated namespace for all resources |
| Deployment | 2 replicas of `nginx:latest` with PVC mounted at `/var/www/html` |
| Service | `ClusterIP` on port 80, port-forwarded to `8080` on the host |
| PersistentVolume | 1Gi `hostPath` volume at `/mnt/data`, `ReadWriteOnce` |
| PersistentVolumeClaim | Binds to the PV using `local-storage` storage class |
| DaemonSet | Ensures 1 Nginx pod runs on **every node** in the cluster |
| Job | One-time busybox batch task with parallelism of 2 and 4 retries |
| CronJob | Runs every minute to simulate a backup from `/demo-data` to `/backup` |

**Automated Setup (`setup.sh`)**
```bash
# Creates the cluster, applies all manifests, and port-forwards in one command
chmod +x setup.sh && ./setup.sh
```

---

## 🖥️ EC2 All-in-One Testing Instance (`ec2_instance_for_testing_all/`)

A special EC2 instance designed to practice all DevOps tools in one place.

**What gets installed automatically via `user_data.sh`:**
- Docker + Docker Compose
- **KinD** (`v0.31.0`) for local Kubernetes clusters
- **kubectl** (latest stable) with checksum verification
- Git with global config pre-set
- This repo cloned to `/home/ubuntu/DevOps`
- Symlink: `/home/ubuntu/k8s` → `DevOps/KUBERNETES/LondeShubham`
- Shell aliases: `kc` for `kubectl`, `dc` for `docker compose`

**Ports opened:** 22 (SSH), 80 (HTTP), 443 (HTTPS), 8080 (K8s ClusterIP), ICMP (ping)

---

## 🛠️ Tech Stack

| Technology | Usage |
|-----------|-------|
| ![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white) | Infrastructure as Code — AWS provisioning |
| ![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonaws&logoColor=white) | EC2, VPC, S3, DynamoDB |
| ![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white) | Container orchestration (KinD) |
| ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white) | Containerization & Compose |
| ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat&logo=nginx&logoColor=white) | Web server for demos |
| ![Shell](https://img.shields.io/badge/Shell_Script-121011?style=flat&logo=gnu-bash&logoColor=white) | Automation & bootstrapping |

---

## 🚦 Quick Start

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- AWS credentials configured (`aws configure`)
- SSH key pair generated (e.g. `ssh-keygen -t rsa -b 4096 -f terra-key-ec2`)

### Run any Terraform project
```bash
git clone https://github.com/Dev00333/DevOps.git
cd DevOps/TERRAFORM/tf-simple-ec2   # or any other project folder

terraform init
terraform plan
terraform apply
```

### Set up Kubernetes (KinD)
> Easiest via the all-in-one EC2 — it bootstraps everything automatically.
> Or run locally if you have Docker + KinD installed:

```bash
cd KUBERNETES/LondeShubham
chmod +x setup.sh && ./setup.sh
```

---

## 🗺️ Learning Roadmap

- [x] Terraform — EC2, Security Groups, Key Pairs, Variables, Outputs
- [x] Terraform — VPC Modules, Public/Private Subnets, NAT Gateway
- [x] Terraform — Remote State (S3 + DynamoDB)
- [x] Kubernetes — KinD clusters, Deployments, Services, PV/PVC
- [x] Kubernetes — DaemonSets, Jobs, CronJobs
- [ ] Kubernetes — Ingress, ConfigMaps, Secrets
- [ ] CI/CD Pipelines (GitHub Actions / Jenkins)
- [ ] Docker — Multi-stage builds, custom images
- [ ] Monitoring (Prometheus + Grafana)
- [ ] Helm Charts

---

## 👤 Author

**Devang Mishra (Dev00333)**
📧 devangmshr@gmail.com
🔗 [GitHub](https://github.com/Dev00333)

---

*⭐ Star this repo if it helped you — it keeps the learning going!*
