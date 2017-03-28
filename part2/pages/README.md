## Kr8ssword Puzzle Kubernetes CI / CD , Microservices Example

# setup
Go through part1. Ensure that:
 - europa is up and running

### Update k8s/deployment.yaml to replace MINIKUBEIP with your minikube ip
    host: kr8sswordz.MINIKUBEIP.xip.io

## Manual steps to build and deploy
### Build and Push to Europa
    docker build -t `minikube ip`:30912/kr8sswordz:1.0.0 .
    docker push `minikube ip`:30912/kr8sswordz:1.0.0
    
### Deploy to kubernetes
    kubectl apply -f k8s/deployment.yaml
    
## Automated script
    ./build.sh
