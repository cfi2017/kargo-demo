# kargo-demo

Release flow for a simple web server using the following CI-CD components:
- Github Actions (building artifacts)
- Github Registry
- ArgoCD (GitOps deployments)
- Kargo (Promotions)

## Stages

The following stages are defined:
- dev: last successfully built main branch
- test: last successfully built tag
- qas: last successfully tested tag
- prod: manual promotion of last successfully built tag
