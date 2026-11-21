# Kubernetes Deployment Guide

This repository contains Kubernetes manifests for deploying a sample application with Nginx and MySQL database.

## Prerequisites

- Kubernetes (Kind cluster recommended)
- kubectl installed and configured
- Docker or container runtime

## Project Structure

```
LondeShubham/
├── first.yaml              # Kind cluster configuration
├── setup.sh               # Deployment script
├── Nginx/                 # Nginx web services
│   ├── namespace.yaml     # Nginx namespace
│   ├── deployment.yaml    # Nginx deployment
│   ├── service.yaml       # Nginx service
│   ├── pv.yaml            # Persistent volume
│   ├── pvc.yaml           # Persistent volume claim
│   ├── ingress.yaml       # Ingress configuration
│   ├── Job.yaml           # Batch job
│   ├── cronjob.yaml       # Cron job
│   ├── daemon.yaml        # DaemonSet
│   └── replica.yaml       # ReplicaSet
├── StatefulSets/          # MySQL StatefulSets
│   ├── namespace.yaml     # MySQL namespace
│   ├── service.yaml       # MySQL service
│   └── statefulset.yaml   # MySQL statefulset
└── mysql/                 # MySQL specific resources
    ├── namespace.yaml     # MySQL namespace
    ├── statefulsets.yaml  # MySQL statefulset
    ├── secret.yaml        # MySQL secrets
    └── service.yaml       # MySQL service
```

## Quick Start

### 1. Create Kind Cluster

```bash
kind create cluster --name=kind-cluster --config=first.yaml
```

### 2. Deploy Application

```bash
cd LondeShubham
./setup.sh
```

### 3. Verify Deployment

```bash
kubectl get pods -n nginx
kubectl get pods -n mysql
kubectl get svc -n nginx
kubectl get svc -n mysql
```

## Accessing Applications

### Nginx
```bash
kubectl port-forward service/nginx-service 8080:80 -n nginx
# Then open http://localhost:8080 in your browser
```

### MySQL
```bash
kubectl port-forward service/mysql-service 3306:3306 -n mysql
# Connect using mysql client with root user
```

## Resources Overview

### Nginx Namespace
- **Deployment**: nginx-deployment (2 replicas)
- **Service**: nginx-service (ClusterIP)
- **Ingress**: simple-ingress (routes traffic to nginx and notes-app)
- **Job**: batch-job (one-time batch processing)
- **CronJob**: backup-cronjob (daily backups)
- **DaemonSet**: nginx-daemonset (runs on all nodes)
- **ReplicaSet**: nginx-replicaset (2 replicas)

### MySQL Namespace
- **StatefulSet**: mysql-statefulsets (3 replicas)
- **Service**: mysql-service (ClusterIP)
- **Secret**: mysql-secret (contains credentials)

## Environment Variables

### MySQL
- `MYSQL_ROOT_PASSWORD`: root (base64 encoded in secret)
- `MYSQL_DATABASE`: devops

### Nginx
- No environment variables required

## Storage

### Persistent Volumes
- **local-pv**: HostPath volume at /mnt/data
- **local-pvc**: Claim for Nginx deployment (1Gi)
- **mysql-data**: Dynamic PVC for MySQL (1Gi)

## Security Considerations

- Secrets are stored in Kubernetes Secret resources
- MySQL credentials are managed via Secret references
- Network policies should be implemented for production

## Troubleshooting

### Check Pod Status
```bash
kubectl get pods -n nginx -o wide
kubectl get pods -n mysql -o wide
```

### View Pod Logs
```bash
kubectl logs -f <pod-name> -n nginx
kubectl logs -f <pod-name> -n mysql
```

### Check Events
```bash
kubectl describe pod <pod-name> -n nginx
kubectl describe pod <pod-name> -n mysql
```

## Best Practices Implemented

- ✅ Resource limits and requests defined
- ✅ Health checks (liveness and readiness probes)
- ✅ Labels and annotations for organization
- ✅ Secrets for sensitive data
- ✅ Namespace isolation
- ✅ Persistent storage for stateful applications

## Next Steps

- Implement Network Policies for security
- Add Pod Disruption Budgets for high availability
- Configure proper storage classes
- Set up monitoring and logging
- Implement CI/CD pipeline
