#!/bin/bash

DEV_NAMESPACE=dev
CLOUDFLARE_SECRET_NAME=cloudflare-secret
CLOUDFLARE_SECRET_KEY=cloudflare-api-token
kubectl -n $DEV_NAMESPACE create secret generic $CLOUDFLARE_SECRET_NAME --from-literal=$CLOUDFLARE_SECRET_KEY=$(cat "$HOME/.athmos/cloudflare") > /dev/null 2>&1