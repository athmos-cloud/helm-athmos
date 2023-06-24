#!/bin/bash

COMMON_NAMESPACE=common
INFRA_NAMESPACE=infra
GATEWAY_NAMESPACE=gateway
CERT_MANAGER_NAMESPACE=cert-manager

kubectl create namespace "$COMMON_NAMESPACE"  > /dev/null 2>&1
kubectl create namespace "$INFRA_NAMESPACE" > /dev/null 2>&1
kubectl create namespace "$GATEWAY_NAMESPACE" > /dev/null 2>&1
kubectL create namespace "$CERT_MANAGER_NAMESPACE" > /dev/null 2>&1

CLOUDFLARE_SECRET_NAME=cloudflare-secret
CLOUDFLARE_SECRET_KEY=cloudflare-api-token
kubectl -n $COMMON_NAMESPACE create secret generic $CLOUDFLARE_SECRET_NAME --from-literal=$CLOUDFLARE_SECRET_KEY=$(cat "$HOME/.athmos/cloudflare") > /dev/null 2>&1
kubectl -n $CERT_MANAGER_NAMESPACE create secret generic $CLOUDFLARE_SECRET_NAME --from-literal=$CLOUDFLARE_SECRET_KEY=$(cat "$HOME/.athmos/cloudflare") > /dev/null 2>&1

# NEO4J_NAMESPACE=gateway
# NEO4J_SECRET_NAME=neo4j-secrets
# NEO4J_PASSWORD=$(openssl rand -base64 15)

# kubectl create namespace "$NEO4J_NAMESPACE" > /dev/null 2>&1
# kubectl -n $NEO4J_NAMESPACE create secret generic $NEO4J_SECRET_NAME --from-literal=NEO4J_DATA=$NEO4J_PASSWORD > /dev/null 2>&1

MONGODB_SECRET_NAME=mongodb-auth
MONGODB_PASSWORD=$(openssl rand -base64 15)
MONGODB_ROOT_PASSWORD=$(openssl rand -base64 15)
kubectl -n $INFRA_NAMESPACE create secret generic  $MONGODB_SECRET_NAME \
            --from-literal=mongodb-passwords=$MONGODB_SECRET_NAME --from-literal=mongodb-root-password=$MONGODB_ROOT_PASSWORD> /dev/null 2>&1

COMMON_NAMESPACE=common
RABBITMQ_SECRET_NAME=rabbitmq-auth
RABBITMQ_PASSWORD=$(openssl rand -base64 15)

kubectl -n $COMMON_NAMESPACE create secret generic $RABBITMQ_SECRET_NAME \
            --from-literal=rabbitmq-password=$RABBITMQ_SECRET_NAME > /dev/null 2>&1

kubectl -n $INFRA_NAMESPACE create secret generic $RABBITMQ_SECRET_NAME \
            --from-literal=rabbitmq-password=$RABBITMQ_SECRET_NAME > /dev/null 2>&1

kubectl -n $GATEWAY_NAMESPACE create secret generic $RABBITMQ_SECRET_NAME \
            --from-literal=rabbitmq-password=$RABBITMQ_SECRET_NAME > /dev/null 2>&1