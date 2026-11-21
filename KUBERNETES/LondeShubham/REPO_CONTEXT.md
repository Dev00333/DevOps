# Kubernetes Repository Context - LondeShubham

## Repository Overview
- **Path**: `c:\Users\Devang Mishra\OneDrive\Desktop\workspace\Devops_Practice\Kubernetes\LondeShubham`
- **Type**: Kubernetes manifests and configurations
- **Purpose**: Sample Kubernetes deployment with Nginx web server and MySQL database

## Project Structure

### Root Level
| File | Purpose |
|------|---------|
| `first.yaml` | Kind cluster configuration (control plane + 2 worker nodes) |
| `setup.sh` | Deployment automation script |
| `README.md` | Documentation and usage guide |

### Nginx Namespace (`namespace: nginx`)
| File | Resource | Description |
|------|----------|-------------|
| `namespace.yaml` | Namespace | Creates nginx namespace |
| `deployment.yaml` | Deployment | Nginx deployment with PVC (2 replicas) |
| `service.yaml` | Service | Nginx ClusterIP service (port 80) |
| `ingress.yaml` | Ingress | Routes /nginx to nginx-service, /app to notes-app-service |
| `pv.yaml` | PersistentVolume | HostPath PV at /mnt/data (1Gi) |
| `pvc.yaml` | PersistentVolumeClaim | Claim for deployment (1Gi, ReadWriteOnce) |
| `Job.yaml` | Job | Batch job (completions: 1, parallelism: 2) |
| `cronjob.yaml` | CronJob | Backup cronjob (schedule: */5 * * * *) |
| `daemon.yaml` | DaemonSet | Nginx daemonset on all nodes |
| `replica.yaml` | ReplicaSet | Nginx replicaset (2 replicas) |

### StatefulSets Namespace (`namespace: mysql`)
| File | Resource | Description |
|------|----------|-------------|
| `namespace.yaml` | Namespace | Creates mysql namespace |
| `statefulset.yaml` | StatefulSet | MySQL statefulset (3 replicas) |
| `service.yaml` | Service | MySQL Headless service (clusterIP: None) |

### MySQL Namespace (`namespace: mysql`)
| File | Resource | Description |
|------|----------|-------------|
| `namespace.yaml` | Namespace | MySQL namespace |
| `statefulsets.yaml` | StatefulSet | MySQL statefulset with secret reference |
| `secret.yaml` | Secret | MySQL credentials (MYSQL_ROOT_PASSWORD, MYSQL_DATABASE) |
| `service.yaml` | Service | MySQL Headless service |

## Resource Relationships

### Nginx Dependencies
```
Ingress (simple-ingress)
  ├── Service (nginx-service:80)
  │     └── Deployment (nginx-deployment)
  │           └── Pod (nginx-deployment-pod)
  │                 └── PVC (local-pvc)
  │                 └── PV (local-pv)
  │
  └── Ingress Path: /app → notes-app-service (not implemented)
```

### MySQL Dependencies
```
StatefulSet (mysql-statefulsets)
  ├── Service (mysql-service)
  │     └── Pods (3 replicas)
  │           └── Container (mysql:8.0)
  │                 └── VolumeClaimTemplate (mysql-data)
  │
  └── Secret (mysql-secret)
        └── Reference in StatefulSet env vars
```

## Resource Specifications

### Kind Cluster
- **Control Plane**: 1 node (kindest/node:v1.32.0)
- **Worker Nodes**: 2 nodes (kindest/node:v1.32.0)
- **Port Mappings**:
  - 443 → 443 (HTTPS)
  - 80 → 80 (HTTP)

### Nginx Deployment
- **Replicas**: 2
- **Image**: nginx:latest
- **Port**: 80
- **Storage**: 1Gi PVC (ReadWriteOnce)
- **Resources**:
  - Limits: CPU 500m, Memory 256Mi
  - Requests: CPU 100m, Memory 128Mi
- **Health Checks**:
  - Liveness: HTTP GET /:80 (initialDelay: 30s, period: 10s)
  - Readiness: HTTP GET /:80 (initialDelay: 5s, period: 5s)

### MySQL StatefulSet
- **Replicas**: 3
- **Image**: mysql:8.0
- **Port**: 3306
- **Storage**: 1Gi PVC (ReadWriteOnce, my-storage-class)
- **Resources**:
  - Limits: CPU 500m, Memory 512Mi
  - Requests: CPU 100m, Memory 256Mi
- **Environment Variables**:
  - MYSQL_ROOT_PASSWORD: from secret
  - MYSQL_DATABASE: devops

### Persistent Storage
| Name | Type | Capacity | Access Mode | Path |
|------|------|----------|-------------|------|
| local-pv | PersistentVolume | 1Gi | ReadWriteOnce | /mnt/data |
| local-pvc | PersistentVolumeClaim | 1Gi | ReadWriteOnce | - |
| mysql-data | VolumeClaimTemplate | 1Gi | ReadWriteOnce | /var/lib/mysql |

## Service Accounts & Namespaces

| Namespace | Purpose |
|-----------|---------|
| nginx | Web services, batch jobs, cron jobs |
| mysql | Database services |

## Security Considerations

### Implemented
- ✅ Secrets for MySQL credentials
- ✅ Resource limits to prevent resource exhaustion
- ✅ Health checks for container monitoring

### Recommended (Not Implemented)
- ⚠️ Network Policies for traffic isolation
- ⚠️ Pod Disruption Budgets for high availability
- ⚠️ RBAC for access control
- ⚠️ Image security scanning

## Best Practices Applied

1. **Resource Management**
   - Resource limits and requests for all containers
   - Appropriate CPU and memory allocation

2. **Health Monitoring**
   - Liveness probes for auto-recovery
   - Readiness probes for traffic routing

3. **Secret Management**
   - Credentials stored in Kubernetes Secrets
   - Base64 encoded sensitive data

4. **Namespace Isolation**
   - Separate namespaces for different services
   - Organized resource grouping

5. **Storage Management**
   - Persistent volumes for stateful applications
   - Proper access modes defined

## Deployment Order

1. Create Kind cluster
2. Deploy namespace (nginx, mysql)
3. Deploy PersistentVolume
4. Deploy PersistentVolumeClaim
5. Deploy Nginx deployment
6. Deploy Nginx service
7. Deploy MySQL StatefulSet
8. Deploy MySQL service
9. Deploy Ingress
10. Deploy batch jobs (Job, CronJob)
11. Deploy DaemonSet and ReplicaSet

## Testing Checklist

- [ ] Kind cluster creation successful
- [ ] Namespaces created (nginx, mysql)
- [ ] Pods running in nginx namespace
- [ ] Pods running in mysql namespace
- [ ] Services exposed correctly
- [ ] Ingress routes traffic properly
- [ ] Persistent volumes mounted
- [ ] MySQL database accessible
- [ ] Nginx serving content

## Known Issues & TODOs

1. **Missing**: Network policies for security
2. **Missing**: Pod disruption budgets
3. **Missing**: Notes-app-service for Ingress routing
4. **TODO**: Implement proper storage class
5. **TODO**: Add monitoring and logging
6. **TODO**: Set up CI/CD pipeline

## Version Information

- **Kubernetes API Versions Used**:
  - `apps/v1` (Deployments, StatefulSets, DaemonSets, ReplicaSets)
  - `batch/v1` (Jobs, CronJobs)
  - `v1` (Namespaces, Services, PersistentVolumes, Secrets)
  - `networking.k8s.io/v1` (Ingress)
  - `kind.x-k8s.io/v1alpha4` (Kind cluster)

- **Images Used**:
  - nginx:latest
  - mysql:8.0
  - busybox:latest

## Contact & Support

For issues or questions about this repository, refer to the README.md file.
