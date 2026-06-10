# 🚀 DevOps Journey — Devang Mishra

> A hands-on DevOps learning repository documenting my practical experience across Infrastructure as Code, Cloud Provisioning, CI/CD, and Container Orchestration.

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Shell Script](https://img.shields.io/badge/Shell-121011?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)

---

## 📁 Repository Structure

```
DevOps/
│
├── TERRAFORM/
│   ├── tf-simple-ec2/              # Basic EC2 with multi-instance type provisioning
│   ├── practice-ec2/               # EC2 with Docker + Nginx built from source
│   ├── testing/                    # EC2 auto-deploying a BMI Calculator app
│   ├── knowledge_refresh/          # Full multi-AZ VPC setup (public + private subnets)
│   └── remote-infra/               # S3 + DynamoDB remote state backend
│
├── KUBERNETES/
│   └── LondeShubham/
│       ├── first.yaml              # KinD cluster config (1 control-plane + 2 workers)
│       ├── setup.sh                # One-command cluster setup & Nginx deployment
│       ├── ingress.yaml            # Nginx Ingress routing to Nginx + Django app
│       ├── notes-app.sh            # Script to deploy the Django Notes App on K8s
│       ├── Nginx/                  # Full Nginx workload manifests
│       │   ├── namespace.yaml
│       │   ├── deployment.yaml     # 2-replica Deployment with PVC
│       │   ├── service.yaml        # ClusterIP on port 80
│       │   ├── pv.yaml             # 1Gi hostPath PersistentVolume
│       │   ├── pvc.yaml            # PersistentVolumeClaim
│       │   ├── daemon.yaml         # DaemonSet: 1 Nginx pod per node
│       │   ├── Job.yaml            # One-time batch Job (busybox)
│       │   └── cronjob.yaml        # Scheduled CronJob (backup simulation)
│       ├── StatefulSets/           # MySQL StatefulSet (3 replicas, volumeClaimTemplates)
│       │   ├── namespace.yaml
│       │   ├── service.yaml
│       │   └── statefulset.yaml
│       ├── mysql/                  # Alternate MySQL StatefulSet with custom StorageClass
│       │   ├── namespace.yaml
│       │   └── statefulsets.yaml
│       └── projects/
│           └── django-notes-app/   # Git submodule: LondheShubham153/django-notes-app
│
├── jenkins_ec2_setup/
│   ├── step_1/                     # Remote state backend (S3 + DynamoDB)
│   └── step_2/                     # Jenkins EC2 with full VPC, SG, and auto-install
│
└── ec2_instance_for_testing_all/   # All-in-one EC2: Docker + KinD + kubectl bootstrapped
```

---

## ☁️ Terraform Projects

### `tf-simple-ec2`
The starting point. Provisions an EC2 instance with:
- Key pair, security group (SSH/HTTP/HTTPS), and default VPC
- `for_each` to spin up **three instance types** simultaneously: `t3.micro`, `t3.small`, `c7i-flex.large`
- Conditional storage sizing based on environment — `prd` gets 10GB, others use default
- User data installs Nginx, Docker, and Docker Compose

### `practice-ec2`
A more refined EC2 setup that adds:
- ICMP (ping) ingress for connectivity testing
- User data that installs Docker, Docker Compose, and builds **Nginx from source** (`nginx-1.29.7`)
- Variables for AMI, instance type, and storage type/size

### `testing`
EC2 that auto-deploys a real app on boot:
- Opens port **3000** alongside standard SSH/HTTP/HTTPS
- User data clones the [BMI Calculator](https://github.com/Dev00333/bmi-calculator) repo and runs it via `docker compose up -d`
- Full logging to `/var/log/user-data.log` with non-interactive apt config

### `knowledge_refresh`
The most advanced Terraform project — production-grade multi-subnet VPC in **eu-north-1**:
- Uses the `terraform-aws-modules/vpc/aws` module with a `10.0.0.0/16` CIDR
- **3 public subnets** + **3 private subnets** across AZs `eu-north-1a/b/c`
- NAT Gateway + VPN Gateway enabled
- Deploys **3 public** and **3 private** EC2 instances using `for_each`
- Separate key pairs and security groups for public vs. private instances
- Private instances accept SSH only from within the VPC CIDR

### `remote-infra`
Terraform remote state backend infrastructure:
- **S3 bucket** for storing `.tfstate` files
- **DynamoDB table** with `LockID` hash key for state locking
- Prevents concurrent `terraform apply` conflicts in team environments

---

## 🖥️ Jenkins EC2 Setup (`jenkins_ec2_setup/`)

A two-phase Terraform setup for provisioning a production-ready Jenkins server.

### Step 1 — Remote State Backend
Sets up an S3 bucket and DynamoDB table (same pattern as `remote-infra/`) so all subsequent Jenkins infrastructure state is stored and locked remotely.

### Step 2 — Jenkins EC2
Provisions a full network stack and EC2 instance:

| Resource | Details |
|----------|---------|
| VPC | `10.0.0.0/16`, DNS support + hostnames enabled |
| Subnet | `10.0.1.0/24` in `eu-north-1a`, auto-assigns public IP |
| Internet Gateway + Route Table | Full internet access for the subnet |
| Security Group | SSH (22), Jenkins UI (8080), App testing (8000), unrestricted egress |
| EC2 Instance | Configurable AMI, instance type, and EBS storage via variables |

**`user_data.sh` auto-installs on first boot:**
- Docker (`docker.io`)
- OpenJDK 21 (JRE)
- Jenkins (from official Debian stable repo, `jenkins.io-2026.key`)
- Jenkins and Docker services enabled on boot
- `ubuntu` and `jenkins` users added to the `docker` group

---

## ☸️ Kubernetes Projects (`KUBERNETES/LondeShubham/`)

All exercises run on a local [KinD](https://kind.sigs.k8s.io/) cluster.

### Cluster Setup (`first.yaml`)
- 1 control-plane + 2 worker nodes using `kindest/node:v1.32.0`
- Worker nodes expose host ports `80` and `443`

### Nginx App Stack

| Resource | Details |
|----------|---------|
| Namespace | `nginx` — all resources isolated here |
| Deployment | 2 replicas of `nginx:latest`, PVC mounted at `/var/www/html` |
| Service | `ClusterIP` on port 80, port-forwarded to `8080` on host |
| PersistentVolume | 1Gi `hostPath` at `/mnt/data`, `ReadWriteOnce` |
| PersistentVolumeClaim | Binds to PV via `local-storage` StorageClass |
| DaemonSet | 1 Nginx pod per node across the cluster |
| Job | One-time busybox batch task, parallelism=2, backoffLimit=4 |
| CronJob | Runs every minute; simulates backup from `/demo-data` → `/backup` |

**One-command setup:**
```bash
chmod +x setup.sh && ./setup.sh
# Creates the KinD cluster, applies all manifests, and port-forwards to localhost:8080
```

### Ingress (`ingress.yaml`)
Nginx Ingress Controller routing in the `nginx` namespace:

| Path | Backend | Port |
|------|---------|------|
| `/nginx(/\|$)(.*)` | `nginx-service` | 80 |
| `/app(/\|$)(.*)` | `notes-app-service` | 8000 |

### MySQL StatefulSet (`StatefulSets/`)
3-replica MySQL StatefulSet demonstrating stable storage across pod restarts:
- Image: `mysql:8.0`, port `3306`
- `MYSQL_ROOT_PASSWORD=root`, `MYSQL_DATABASE=devops`
- `volumeClaimTemplates` provisions a **1Gi PVC per replica** (`ReadWriteOnce`)

An alternate version lives in `mysql/` using a custom `StorageClass` name (`my-storage-class`).

### Django Notes App (`projects/`, `notes-app.sh`)
Deploys a containerised Django notes application to Kubernetes.

`notes-app.sh` is an automated setup script that:
1. Clones [Dev00333/django-notes-app](https://github.com/Dev00333/django-notes-app) (or pulls if already present)
2. Creates a `k8s/` directory inside the repo
3. Injects three manifests programmatically:

| Manifest | Details |
|----------|---------|
| `namespace.yaml` | Namespace `notes-app` |
| `deployment.yaml` | 1 replica of `devang0003/notes-app-k8s:latest` on port `8000` |
| `service.yaml` | `ClusterIP` on port `8000` |

```bash
chmod +x notes-app.sh && ./notes-app.sh
kubectl apply -f ~/k8s/projects/django-notes-app/k8s/
```

---

## 🖥️ All-in-One Testing EC2 (`ec2_instance_for_testing_all/`)

A dedicated EC2 instance to practise all DevOps tools in one environment.

**Ports opened:** 22 (SSH), 80 (HTTP), 443 (HTTPS), 8080 (K8s port-forward), ICMP (ping)

**Auto-bootstrapped via `user_data.sh`:**

| Tool | Version |
|------|---------|
| Docker + Docker Compose | Latest apt stable |
| KinD | `v0.31.0` |
| kubectl | Latest stable (with sha256 checksum verification) |
| Git | Pre-configured with global user/email |

Additional setup on first boot:
- This repo cloned to `/home/ubuntu/DevOps`
- Symlink: `/home/ubuntu/k8s` → `DevOps/KUBERNETES/LondeShubham`
- Shell aliases: `kc` = `kubectl`, `dc` = `docker compose`

---

## 🚦 Quick Start

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) installed locally
- AWS credentials configured (`aws configure`)
- SSH key pair generated (e.g. `ssh-keygen -t rsa -b 4096 -f terra-key-ec2`)

### Terraform (any project)
```bash
git clone https://github.com/Dev00333/DevOps.git
cd DevOps/TERRAFORM/<project-folder>

terraform init
terraform plan
terraform apply
```

### Jenkins EC2
```bash
# Step 1: Create remote state infrastructure
cd DevOps/jenkins_ec2_setup/step_1
terraform init && terraform apply

# Step 2: Provision Jenkins server
cd ../step_2
terraform init && terraform apply
# Access Jenkins at http://<EC2_PUBLIC_IP>:8080
```

### Kubernetes (KinD, local)
> Easiest path: spin up the all-in-one EC2 — everything bootstraps automatically on first boot.
> Or run locally with Docker + KinD already installed:

```bash
cd KUBERNETES/LondeShubham
chmod +x setup.sh && ./setup.sh
# Nginx available at localhost:8080

# Deploy Django Notes App
chmod +x notes-app.sh && ./notes-app.sh
kubectl apply -f ~/k8s/projects/django-notes-app/k8s/
```

---

## 🗺️ Learning Roadmap

- [x] Terraform — EC2, Security Groups, Key Pairs, Variables, Outputs
- [x] Terraform — VPC Modules, Public/Private Subnets, NAT Gateway
- [x] Terraform — Remote State (S3 + DynamoDB state locking)
- [x] Kubernetes — KinD clusters, Deployments, Services, PV/PVC
- [x] Kubernetes — DaemonSets, Jobs, CronJobs
- [x] Kubernetes — StatefulSets (MySQL with volumeClaimTemplates)
- [x] Kubernetes — Ingress (path-based routing)
- [x] Kubernetes — Multi-service app deployment (Django Notes App)
- [x] CI/CD — Jenkins provisioned via Terraform on AWS
- [ ] GitHub Actions pipelines (build → push → deploy)
- [ ] Docker — Multi-stage builds, custom images
- [ ] Helm Charts
- [ ] Monitoring (Prometheus + Grafana)
- [ ] EKS (managed Kubernetes on AWS)

---

## 🛠️ Tech Stack

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazonaws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat&logo=nginx&logoColor=white)
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=flat&logo=gnu-bash&logoColor=white)

| Technology | Usage |
|-----------|-------|
| Terraform | IaC — AWS provisioning, VPC modules, remote state |
| AWS | EC2, VPC, S3, DynamoDB, IAM |
| Kubernetes | Container orchestration (KinD + manifests) |
| Docker | Containerisation & Docker Compose |
| Jenkins | CI/CD server, Terraform-provisioned on AWS |
| Nginx | Web server & Ingress Controller |
| Shell Script | Automation, bootstrapping, setup scripts |

---

## 👤 Author

**Devang Mishra**  
📧 devangmshr@gmail.com  
🔗 [github.com/Dev00333](https://github.com/Dev00333)

---

*⭐ Star this repo if it helped you — it keeps the learning going!*
