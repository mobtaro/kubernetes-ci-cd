#!/bin/bash

#Retrieve the latest git commit hash
BUILD_TAG=`git rev-parse --short HEAD`

#Build the docker image
docker build -t localhost:30400/kr8sswordz:$BUILD_TAG --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy -f applications/kr8sswordz-pages/Dockerfile applications/kr8sswordz-pages

#Setup the proxy for the registry
docker stop socat-registry; docker rm socat-registry; docker run -d -e "REG_IP=${K8S_IP}" -e "REG_PORT=32000" --name socat-registry -p 30400:5000 socat-registry

echo "5 second sleep to make sure the registry is ready"
sleep 5;

#Push the images
docker push localhost:30400/kr8sswordz:$BUILD_TAG

#Stop the registry proxy
docker stop socat-registry

# Create the deployment and service for the front end aka kr8sswordz
sed -e 's#127.0.0.1:30400/kr8sswordz:$BUILD_TAG#localhost:32000/kr8sswordz:'$BUILD_TAG'#' -e "s/192.168.99.100/${K8S_IP}/" applications/kr8sswordz-pages/k8s/deployment.yaml | kubectl apply -f -
