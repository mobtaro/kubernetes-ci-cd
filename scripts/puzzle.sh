#!/bin/bash

#Retrieve the latest git commit hash
BUILD_TAG=`git rev-parse --short HEAD`

#Build the docker image
docker build -t localhost:30400/puzzle:$BUILD_TAG --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy -f applications/puzzle/Dockerfile applications/puzzle

#Setup the proxy for the registry
docker stop socat-registry; docker rm socat-registry; docker run -d -e "REG_IP=${K8S_IP}" -e "REG_PORT=32000" --name socat-registry -p 30400:5000 socat-registry

echo "5 second sleep to make sure the registry is ready"
sleep 5;

#Push the images
docker push localhost:30400/puzzle:$BUILD_TAG

#Stop the registry proxy
docker stop socat-registry

# Create the deployment and service for the puzzle server aka puzzle
sed -e 's#127.0.0.1:30400/puzzle:$BUILD_TAG#localhost:32000/puzzle:'$BUILD_TAG'#' -e "s/192.168.99.100/${K8S_IP}/" applications/puzzle/k8s/deployment.yaml | kubectl apply -f -
#sed -e 's#127.0.0.1:30400/monitor-scale:$BUILD_TAG#localhost:32000/monitor-scale:'`git rev-parse --short HEAD`'#' -e "s/192.168.99.100/${K8S_IP}/" applications/monitor-scale/k8s/deployment.yaml | kubectl apply -f -

