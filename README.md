# Application-Microservice-1

A simple static Todo web application containerised with nginx and deployed to AKS via ArgoCD GitOps.

## Overview

```
Developer pushes code to main
        │
GitHub Actions builds Docker image
        │
Pushes image to Azure Container Registry (cloudzenprodacr)
        │
ArgoCD Image Updater detects new digest
        │
Auto-deploys to AKS (todo-app namespace)
        │
Accessible at http://<LB-IP>/todo
```

## Repository Structure

```
Application-Microservice-1/
├── src/
│   └── index.html       # Todo app (vanilla HTML/CSS/JS, localStorage-based)
├── Dockerfile           # nginx:alpine serving src/
└── README.md
```

## Application

- **Stack:** Static HTML + CSS + JavaScript (no backend, no database)
- **Server:** nginx:alpine
- **Port:** 80
- **Data:** Stored in browser localStorage (no persistence between browsers)

## Local Development

```bash
# Build image
docker build -t todo-app .

# Run locally
docker run -p 8080:80 todo-app

# Open http://localhost:8080
```

## CI/CD Pipeline

On every push to `main`, GitHub Actions:
1. Builds the Docker image
2. Pushes it to `cloudzenprodacr.azurecr.io/todo-app:latest`
3. ArgoCD Image Updater detects the new digest within 2 minutes
4. Automatically deploys to the AKS cluster

## Required GitHub Secrets & Variables

### Repository Variables (`vars.*`)

| Name | Description |
|---|---|
| `AZURE_CLIENT_ID` | Client ID of the Azure Managed Identity used for OIDC login |
| `AZURE_TENANT_ID` | Azure Active Directory Tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID |

### No secrets required

Authentication to ACR uses the Azure Managed Identity via OIDC — no passwords stored in GitHub.

### Where to find these values

- **AZURE_CLIENT_ID / TENANT_ID / SUBSCRIPTION_ID** — Azure Portal → Managed Identity `cloudzen-prod-mi` → Overview

## Related Repositories

| Repository | Purpose |
|---|---|
| [Azure-Infrastructure](https://github.com/Chandru3493/Azure-Infrastructure) | Terraform — provisions AKS, ACR, networking |
| [AKS-GitOps](https://github.com/Chandru3493/AKS-GitOps) | GitOps — deploys this app to AKS via ArgoCD |
