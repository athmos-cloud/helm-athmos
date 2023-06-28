#!/bin/bash

FRONTEND_NAMESPACE=frontend
COMMON_NAMESPACE=common
INFRA_NAMESPACE=infra
GATEWAY_NAMESPACE=gateway
CERT_MANAGER_NAMESPACE=cert-manager


kubectl create namespace "$FRONTEND_NAMESPACE" > /dev/null 2>&1
kubectl create namespace "$COMMON_NAMESPACE"  > /dev/null 2>&1
kubectl create namespace "$INFRA_NAMESPACE" > /dev/null 2>&1
kubectl create namespace "$GATEWAY_NAMESPACE" > /dev/null 2>&1
kubectl create namespace "$CERT_MANAGER_NAMESPACE" > /dev/null 2>&1


CLOUDFLARE_SECRET_NAME=cloudflare-secret
CLOUDFLARE_SECRET_KEY=cloudflare-api-token
kubectl -n $CERT_MANAGER_NAMESPACE create secret generic $CLOUDFLARE_SECRET_NAME --from-literal=$CLOUDFLARE_SECRET_KEY=$(cat "$HOME/.athmos/cloudflare") > /dev/null 2>&1

NEO4J_NAMESPACE=gateway
NEO4J_SECRET_NAME=neo4jsecret
NEO4J_API_SECRET_NAME=neo4j-gateway-auth
NEO4J_PASSWORD="$(openssl rand -base64 15)!"

kubectl create namespace "$NEO4J_NAMESPACE" > /dev/null 2>&1
kubectl -n $NEO4J_NAMESPACE create secret generic $NEO4J_SECRET_NAME --from-literal=NEO4J_AUTH="neo4j/$NEO4J_PASSWORD" > /dev/null 2>&1
kubectl -n $NEO4J_NAMESPACE create secret generic $NEO4J_API_SECRET_NAME --from-literal=password=$NEO4J_PASSWORD > /dev/null 2>&1


MONGODB_SECRET_NAME=mongodb-auth
MONGODB_PASSWORD=$(openssl rand -base64 15)
MONGODB_ROOT_PASSWORD=$(openssl rand -base64 15)
kubectl -n $INFRA_NAMESPACE create secret generic  $MONGODB_SECRET_NAME \
            --from-literal=mongodb-passwords=$MONGODB_SECRET_NAME --from-literal=mongodb-root-password=$MONGODB_ROOT_PASSWORD> /dev/null 2>&1

COMMON_NAMESPACE=common
RABBITMQ_SECRET_NAME=rabbitmq-auth
RABBITMQ_PASSWORD=$(openssl rand -base64 15)

kubectl -n $COMMON_NAMESPACE create secret generic $RABBITMQ_SECRET_NAME \
            --from-literal=rabbitmq-password=$RABBITMQ_PASSWORD > /dev/null 2>&1

kubectl -n $INFRA_NAMESPACE create secret generic $RABBITMQ_SECRET_NAME \
            --from-literal=rabbitmq-password=$RABBITMQ_PASSWORD > /dev/null 2>&1

kubectl -n $GATEWAY_NAMESPACE create secret generic $RABBITMQ_SECRET_NAME \
            --from-literal=rabbitmq-password=$RABBITMQ_PASSWORD > /dev/null 2>&1

REGISTRY_CREDENTIALS_SECRET_NAME=regcred
REGISTRY_SERVER=https://registry.athmos-cloud.com/athmos/
DOCKER_USERNAME="robot\$kubernetes-puller"
kubectl -n $INFRA_NAMESPACE create secret docker-registry $REGISTRY_CREDENTIALS_SECRET_NAME \
    --docker-server=$REGISTRY_SERVER --docker-username=$DOCKER_USERNAME --docker-password="$(cat "$HOME/.athmos/registry-pwd")" > /dev/null 2>&1
kubectl -n $GATEWAY_NAMESPACE create secret docker-registry $REGISTRY_CREDENTIALS_SECRET_NAME \
    --docker-server=$REGISTRY_SERVER --docker-username=$DOCKER_USERNAME --docker-password="$(cat "$HOME/.athmos/registry-pwd")" > /dev/null 2>&1
kubectl -n $FRONTEND_NAMESPACE create secret docker-registry $REGISTRY_CREDENTIALS_SECRET_NAME \
    --docker-server=$REGISTRY_SERVER --docker-username=$DOCKER_USERNAME --docker-password="$(cat "$HOME/.athmos/registry-pwd")" > /dev/null 2>&1

OPERATIONS_KUBECONFIG_SECRET_NAME=operations-kubeconfig
kubectl -n $INFRA_NAMESPACE create secret generic $OPERATIONS_KUBECONFIG_SECRET_NAME \
    --from-file=config="$HOME/.athmos/operation-kubeconfig" > /dev/null 2>&1


ADMIN_PASSWORD_SECRET_NAME=admin-secret
ADMIN_PASSWORD=$(openssl rand -base64 21)

kubectl -n $GATEWAY_NAMESPACE create secret generic $ADMIN_PASSWORD_SECRET_NAME \
    --from-literal=password=$ADMIN_PASSWORD > /dev/null 2>&1

SECRET_API_SECRET_NAME=secret-api-secret
SECRET_API_PASSWORD=$(openssl rand -base64 21)
kubectl -n $GATEWAY_NAMESPACE create secret generic $SECRET_API_SECRET_NAME \
    --from-literal=secret=$SECRET_API_PASSWORD > /dev/null 2>&1