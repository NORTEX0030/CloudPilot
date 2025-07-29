## Craftista - Microservices Application

A complete microservices application with CI/CD pipeline, Kubernetes deployment, and GitOps workflow.
## Architecture
#### Microservices

- Frontend (Node.js) - Port 3000
- Catalogue (Python Flask) - Port 5000 + MongoDB
- Recommendation (Go) - Port 8000
- Voting (Java Spring Boot) - Port 8060 + PostgreSQL

#### Infrastructure

- CI/CD: Jenkins Pipeline
- Containerization: Docker
- Orchestration: Kubernetes
- GitOps: ArgoCD
- Configuration Management: Kustomize + Helm
- Visualization: Interactive Architecture Diagrams

Project Structure
```
craftista/ # Application source code          
│   ├── frontend/            # Node.js frontend service
│   ├── catalogue/           # Python Flask catalogue service
│   ├── recommendation/      # Go recommendation service
│   ├── voting/             # Java Spring Boot voting service
│   └── Jenkinsfile         # CI/CD pipeline
├── craftista-k8s/          # Kubernetes manifests (Kustomize)
│   ├── base/               # Base Kustomize manifests
│   ├── overlays/           # Environment-specific overlays
│   │   ├── dev/           # Development environment
│   │   └── staging/       # Staging environment
│   └── argocd/            # ArgoCD application manifests
├── helm-charts/            # Helm charts
│   └── craftista/         # Main Helm chart
│       ├── templates/     # Kubernetes templates
│       ├── values.yaml    # Default values
│       ├── values-dev.yaml    # Dev environment values
│       └── values-staging.yaml # Staging environment values
| 
└── README.md              # This file
```
 Quick Start
#### 1. Prerequisites
```
    Docker
    Kubernetes cluster
    Jenkins
    ArgoCD
    kubectl with cluster access
    Helm (optional)
```
#### 2. Build and Deploy

Option A: Kustomize Deployment

#### Deploy with Kustomize
```
kubectl apply -k craftista-k8s/overlays/dev/
kubectl apply -k craftista-k8s/overlays/staging/
```
Option B: Helm Deployment

#### Deploy with Helm
```
helm install craftista-dev ./helm-charts/craftista -f helm-charts/craftista/values-dev.yaml -n dev --create-namespace
helm install craftista-staging ./helm-charts/craftista -f helm-charts/craftista/values-staging.yaml -n staging --create-namespace
```
Option B: CI/CD Pipeline

Setup Jenkins pipeline pointing to your repository

1. Build Docker images
3. Update K8s manifests
4. ArgoCD deploys automatically

### 3. Access Applications
Development Environment

#### Get service URLs
```
kubectl get svc -n dev
```

#### Port forward for local access
```
kubectl port-forward svc/craftista-frontend-service 3000:3000 -n dev
```
Staging Environment

#### Get service URLs
```
kubectl get svc -n staging
```
#### Port forward for local access
```
kubectl port-forward svc/craftista-frontend-service 3000:3000 -n 
staging
```
- CI/CD Pipeline
- Jenkins Pipeline Features
```
    Parallel Builds: All services build simultaneously
    Docker Registry: Pushes to DockerHub
    GitOps Integration: Updates K8s manifests automatically
    Versioning: Uses build numbers for image tags
```
Required Jenkins Credentials
```
    dockerhub: DockerHub username/password
    git-credentials: GitHub username/token
```
Kubernetes Deployment
Environments
```
    Development (dev namespace)
    Staging (staging namespace)
```
RBAC Configuration
```
    Environment-specific service accounts
    Role-based access control
    Namespace isolation
```
Storage
```
    MongoDB: 1Gi persistent storage for catalogue
    PostgreSQL: 1Gi persistent storage for voting
```
GitOps with ArgoCD
Setup ArgoCD Applications

#### Deploy ArgoCD applications
kubectl apply -f craftista-k8s/argocd/craftista-dev-app.yaml
kubectl apply -f craftista-k8s/argocd/craftista-staging-app.yaml

#### Access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

Features
```
    Automated Sync: Deploys changes from Git automatically
    Self-Healing: Corrects configuration drift
    Rollback: Easy rollback to previous versions
```
Development Workflow
```
    Code Changes: Developers push code to repository
    CI Pipeline: Jenkins builds and tests applications
    Image Build: Docker images built and pushed to registry
    Manifest Update: K8s manifests updated with new image tags
    GitOps Deployment: ArgoCD detects changes and deploys
    Verification: Applications running in target environments
```
Monitoring and Troubleshooting
Check Application Status

#### Pod status
```
kubectl get pods -n dev
kubectl get pods -n staging
```
#### Service status
```
kubectl get svc -n dev
kubectl get svc -n staging
```
#### Logs
```
kubectl logs <pod-name> -n <namespace>
```
ArgoCD Status

#### Application status
```
kubectl get applications -n argocd
```
#### Sync status
```
argocd app get craftista-dev
argocd app get craftista-staging
```
Configuration
Environment Variables
```
    Services communicate via Kubernetes service discovery
    Database connections configured via ConfigMaps
    Secrets managed via Kubernetes Secrets
```
Scaling

#### Scale deployments
kubectl scale deployment craftista-frontend --replicas=3 -n dev

Security
```
    Non-root containers: All services run as non-root users
    RBAC: Role-based access control per environment
    Network policies: Service-to-service communication control
    Secret management: Sensitive data in Kubernetes Secrets
```
Contributing
```
    Fork the repository
    Create feature branch
    Make changes and test locally
    Submit pull request
    CI/CD pipeline will handle deployment
```
Support

For issues and questions:
```
    Check application logs: kubectl logs <pod-name> -n <namespace>
    Verify ArgoCD sync status
    Review Jenkins pipeline logs
    Check Kubernetes events: kubectl get events -n <namespace>
```