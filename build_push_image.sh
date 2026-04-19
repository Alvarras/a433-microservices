#!/bin/bash

# Script untuk Build dan Push Docker Image ke GitHub Packages

# Load environment variables dari .env file
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
else
    echo "Error: .env file not found!"
    echo "Please create .env file based on .env.example"
    exit 1
fi

# Validasi environment variables
if [ -z "$GITHUB_USERNAME" ] || [ -z "$PASSWORD_GITHUB_PACKAGE" ]; then
    echo "Error: GITHUB_USERNAME atau PASSWORD_GITHUB_PACKAGE tidak ditemukan di .env"
    exit 1
fi

# Variabel untuk konfigurasi GitHub Packages
FULL_IMAGE_NAME="${REGISTRY}/${GITHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

# 1. Membuat Docker image dari Dockerfile yang tadi dibuat,dengan nama image item-app, dan memiliki tag v1
echo "=== Step 1: Building Docker Image ==="
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

if [ $? -ne 0 ]; then
    echo "Error: Failed to build Docker image"
    exit 1
fi

echo "Docker image ${IMAGE_NAME}:${IMAGE_TAG} built successfully!"
echo ""

# 2. Melihat daftar image di lokal
echo "=== Step 2: Listing Docker Images ==="
docker images | grep -E "REPOSITORY|${IMAGE_NAME}"
echo ""

# 3. Mengubah nama image agar sesuai dengan format GitHub Packages
echo "=== Step 3: Tagging Image for GitHub Packages ==="
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE_NAME}
echo "Image tagged as: ${FULL_IMAGE_NAME}"
echo ""

# 4. Login ke GitHub Packages via Terminal
echo "=== Step 4: Login to GitHub Packages ==="
echo "Logging in to GitHub Packages..."
echo $PASSWORD_GITHUB_PACKAGE | docker login ${REGISTRY} -u ${GITHUB_USERNAME} --password-stdin

if [ $? -ne 0 ]; then
    echo "Error: Failed to login to GitHub Packages"
    exit 1
fi

echo "Successfully logged in to GitHub Packages"
echo ""

# 5. Mengunggah image ke GitHub Packages
echo "=== Step 5: Pushing Image to GitHub Packages ==="
docker push ${FULL_IMAGE_NAME}

if [ $? -ne 0 ]; then
    echo "Error: Failed to push Docker image"
    exit 1
fi

echo "Docker image ${FULL_IMAGE_NAME} pushed successfully!"
echo ""

# Logout dari GitHub Packages
echo "=== Step 6: Logout from GitHub Packages ==="
docker logout ${REGISTRY}
echo "Logged out from GitHub Packages"
