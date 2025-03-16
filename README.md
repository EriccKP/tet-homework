# Time App - Setup and Deployment Guide

A simple Node.js application displaying the current date and time with Kubernetes deployment manifests.

## Prerequisites

- Node.js v12+
- Docker
- kubectl
- minikube

## Quick Start

### Docker Build and Test

```bash
# Build the image
docker build -t time-app:latest .

# Run locally
docker run -p 3000:3000 time-app:latest

# Test
curl http://localhost:3000
```

## Minikube Deployment

### 1. Start Minikube

```bash
# Start minikube
minikube start
```

### 2. Deploy the Application

```bash
# Apply all manifests
kubectl apply -f deployment.yaml -f service.yaml -f ingress.yaml

# Verify deployment
kubectl get pods,svc
```

### 3. Access the Application

```bash
# Port forward the service to access locally
kubectl port-forward svc/time-app-service 8080:80
```

Then access: http://localhost:8080

## CI/CD Pipeline

GitHub Actions is configured to automatically:
1. Build a new Docker image on push
2. Push the image to Docker Hub
3. Deploy the updated manifests to the Kubernetes cluster

The workflow is defined in the repository's GitHub Actions configuration.

## Troubleshooting

### Common Issues

1. **Pods not starting**:
   ```bash
   kubectl describe pod <pod-name>
   kubectl logs <pod-name>
   ```

2. **Service not routing traffic**:
   ```bash
   kubectl get endpoints time-app-service
   ```

3. **Port forwarding issues**:
   ```bash
   # Check if the service exists
   kubectl get svc time-app-service
   
   # Check if pods are running
   kubectl get pods -l app=time-app
   ```

## Cleanup

```bash
# Remove all resources
kubectl delete -f deployment.yaml -f service.yaml -f ingress.yaml


minikube stop
minikube delete
``` 