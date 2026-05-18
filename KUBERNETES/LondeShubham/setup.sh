#!/bin/bash

kind create cluster --name=kind-cluster --config=/home/ubuntu/k8s/first.yaml
cd /home/ubuntu/k8s/Nginx
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

kubectl wait --for=condition=ready pod -l app=nginx -n nginx --timeout=30s
kubectl port-forward service/nginx-service 8080:80 -n nginx --address=0.0.0.0