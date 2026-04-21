#!/bin/bash

set -e

# Environment variables (dari GitHub Secrets)
IMAGE_NAME="${IMAGE_NAME}"
IMAGE_TAG="${IMAGE_TAG}"
DOCKER_REGISTRY="ghcr.io"

echo "Building and pushing Docker image..."

# Step 1: Build Docker Image
echo "Step 1: Building Docker image..."
if docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .; then
    echo "Docker image built successfully"
else
    echo "Failed to build Docker image"
    exit 1
fi

echo ""

# Step 2: Tag image with registry
echo "Step 2: Tagging image with registry..."
FULL_IMAGE_NAME="${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE_NAME}
echo "Docker image tagged as ${FULL_IMAGE_NAME}"

echo ""

# Step 3: Push image to registry
echo "Step 3: Pushing image to registry..."
if docker push ${FULL_IMAGE_NAME}; then
    echo "Docker image pushed successfully"
else
    echo "Failed to push Docker image"
    exit 1
fi

echo ""
echo "Build and Push Completed Successfully"
echo "Image: ${FULL_IMAGE_NAME}"
