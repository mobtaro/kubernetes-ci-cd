FROM alpine:latest
ARG http_proxy
ARG https_proxy

#USER root
#Installing socat
RUN apk update && apk upgrade && apk add bash socat
COPY entrypoint.sh entrypoint.sh
ENTRYPOINT ["sh", "./entrypoint.sh"]