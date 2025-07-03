# LiteLLM Fork Deployment Guide

This guide explains how to deploy your own version of LiteLLM Docker images and Helm charts to GitHub Container Registry (ghcr.io) from your forked repository.

## What This Setup Provides

When you run the deployment workflow, it will create:

### Docker Images
- `ghcr.io/YOUR_USERNAME/litellm:TAG` - Main LiteLLM proxy image
- `ghcr.io/YOUR_USERNAME/litellm-database:TAG` - LiteLLM with database support
- `ghcr.io/YOUR_USERNAME/litellm-non-root:TAG` - Non-root user version
- `ghcr.io/YOUR_USERNAME/litellm-spend-logs:TAG` - Spend logs service

### Helm Chart
- `ghcr.io/YOUR_USERNAME/litellm-helm:CHART_VERSION` - Kubernetes deployment chart

## Prerequisites

1. **Fork the repository** (already done)
2. **Ensure you have write permissions** to your GitHub Container Registry
3. **Commit the workflow files** to your repository

## How to Deploy

### Step 1: Commit the Files

```bash
git add .github/workflows/deploy-fork.yml
git add update-helm-chart.sh
git commit -m "Add deployment workflow for forked repository"
git push origin main
```

### Step 2: Trigger the Workflow

1. Go to your forked repository on GitHub
2. Navigate to **Actions** → **Deploy LiteLLM Docker Images and Helm Chart to ghcr.io (Fork)**
3. Click **Run workflow**
4. Fill in the parameters:
   - **Tag**: Your version tag (e.g., `v1.0.0`)
   - **Release type**: `latest`, `stable`, `dev`, or `rc`
   - **Commit hash**: The commit you want to build from
   - **Chart version**: (Optional) Specific Helm chart version, will auto-increment if not provided

### Step 3: Monitor the Build

The workflow will:
1. Build all Docker images for multiple platforms (AMD64, ARM64)
2. Push them to your ghcr.io namespace
3. Update the Helm chart to use your Docker images
4. Package and push the Helm chart to your ghcr.io namespace

## Using Your Deployed Images

### Docker Images

```bash
# Pull your images
docker pull ghcr.io/YOUR_USERNAME/litellm:latest
docker pull ghcr.io/YOUR_USERNAME/litellm-database:latest

# Run the proxy
docker run -p 4000:4000 ghcr.io/YOUR_USERNAME/litellm:latest
```

### Helm Chart

```bash
# Add your Helm repository
helm registry login ghcr.io
helm pull oci://ghcr.io/YOUR_USERNAME/litellm-helm --version CHART_VERSION

# Install the chart
helm install my-litellm oci://ghcr.io/YOUR_USERNAME/litellm-helm \
  --version CHART_VERSION \
  --set postgresql.auth.password=your-secure-password \
  --set postgresql.auth.postgres-password=your-secure-password
```

## Customization

### Modifying Docker Images

The workflow uses these Dockerfiles:
- `Dockerfile` - Main image
- `docker/Dockerfile.database` - Database-enabled image
- `docker/Dockerfile.non_root` - Non-root user image
- `litellm-js/spend-logs/Dockerfile` - Spend logs service

### Modifying the Helm Chart

The Helm chart is located in `deploy/charts/litellm-helm/`. The workflow automatically:
- Updates `values.yaml` to use your Docker images
- Updates `Chart.yaml` description to indicate it's a forked version
- Increments the chart version automatically

### Custom Configuration

You can modify the workflow to:
- Add additional Docker images
- Change build platforms
- Add custom build steps
- Modify Helm chart values

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure your GitHub token has `packages:write` permission
2. **Image Not Found**: Check that the workflow completed successfully
3. **Helm Chart Not Found**: Verify the chart version exists in your registry

### Debugging

- Check the workflow logs in GitHub Actions
- Verify images exist: `docker pull ghcr.io/YOUR_USERNAME/litellm:latest`
- Check Helm chart: `helm show chart oci://ghcr.io/YOUR_USERNAME/litellm-helm`

## Security Notes

- The workflow uses `GITHUB_TOKEN` which is automatically available
- Docker images are built with security best practices
- Helm chart uses your own namespace to avoid conflicts
- Consider using specific version tags instead of `latest` in production

## Next Steps

After successful deployment:
1. Test your images locally
2. Deploy to your Kubernetes cluster
3. Set up CI/CD for automatic deployments
4. Consider setting up image scanning and security policies 