#!/bin/bash
set -e

# Check if Kind is installed
if ! command -v kind &> /dev/null; then
    echo "Error: Kind is not installed. Please install Kind first."
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Create Kind cluster
echo "Creating Kind cluster..."
kind create cluster --name=kind-cluster --config=/home/ubuntu/k8s/first.yaml

# Navigate to Nginx namespace
cd /home/ubuntu/k8s/Nginx

# Apply resources in order
echo "Applying namespace..."
kubectl apply -f namespace.yaml

echo "Applying persistent volume..."
kubectl apply -f pv.yaml

echo "Applying persistent volume claim..."
kubectl apply -f pvc.yaml

echo "Applying deployment..."
kubectl apply -f deployment.yaml

echo "Applying service..."
kubectl apply -f service.yaml

# Wait for pods to be ready
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=nginx -n nginx --timeout=30s

# Forward port
echo "Forwarding port 8080:80..."
kubectl port-forward service/nginx-service 8080:80 -n nginx --address=0.0.0.0

echo "Deployment completed successfully!"