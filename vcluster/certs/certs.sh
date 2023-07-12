#!/bin/bash

# Step 1: Generate Certificate Authority (CA) certificate and key
openssl req -new -x509 -days 3650 -nodes -out ca.crt -keyout ca.key -subj "/CN=ca"

# Step 2: Generate server certificate and key
openssl req -new -nodes -out server.csr -keyout server.key -subj "/CN=server"
openssl x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

# Step 3: Generate client certificate and key
openssl req -new -nodes -out client.csr -keyout client.key -subj "/CN=client"
openssl x509 -req -days 3650 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt

# Step 4: Convert server and client certificates to .pem format
openssl x509 -in server.crt -out server.pem -outform PEM
openssl x509 -in client.crt -out client.pem -outform PEM

# Clean up the CSR files
rm -f server.csr client.csr

kubectl -n operations create secret generic etcd-certs --from-file=cert.pem=server.pem --from-file=key.pem=server.key --from-file=ca.crt=ca.crt
rm *.crt *.key *.pem