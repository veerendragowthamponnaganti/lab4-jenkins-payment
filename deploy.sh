#!/bin/bash

ARTIFACT="$1"

echo "======================================"
echo "Starting Production Deployment"
echo "======================================"

if [ -z "$ARTIFACT" ]; then
    echo "ERROR: No artifact provided"
    exit 1
fi

if [ ! -f "$ARTIFACT" ]; then
    echo "ERROR: Artifact not found: $ARTIFACT"
    exit 1
fi

echo "Deploying artifact: $ARTIFACT"

mkdir -p deployed

cp "$ARTIFACT" deployed/payment.jar

echo "Deployed artifact:"
ls -lh deployed/payment.jar

echo "======================================"
echo "Production Deployment Successful"
echo "======================================"