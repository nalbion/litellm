#!/bin/bash

# Script to update Helm chart to use forked repository images
# Usage: ./update-helm-chart.sh [repository-owner]

REPO_OWNER=${1:-$(echo $GITHUB_REPOSITORY_OWNER | tr '[:upper:]' '[:lower:]')}

if [ -z "$REPO_OWNER" ]; then
    echo "Error: Repository owner not provided and GITHUB_REPOSITORY_OWNER not set"
    echo "Usage: ./update-helm-chart.sh [repository-owner]"
    exit 1
fi

echo "Updating Helm chart to use images from: ghcr.io/$REPO_OWNER"

# Update the main image repository
sed -i "s|repository: ghcr.io/berriai/litellm-database|repository: ghcr.io/$REPO_OWNER/litellm-database|g" deploy/charts/litellm-helm/values.yaml

echo "Updated image repository to: ghcr.io/$REPO_OWNER/litellm-database"
echo "Helm chart values.yaml has been updated successfully!" 