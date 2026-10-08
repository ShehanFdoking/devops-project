# Deployment Guide 🚀

This guide covers multiple deployment options for the DevOps Spring Boot application using GitHub Actions.

## Table of Contents
1. [Docker Hub Deployment](#docker-hub-deployment)
2. [Render Deployment](#render-deployment)
3. [Railway Deployment](#railway-deployment)
4. [Heroku Deployment](#heroku-deployment)
5. [AWS Deployment](#aws-deployment)

---

## 1. Docker Hub Deployment 🐳

Deploy your Docker image to Docker Hub for easy distribution.

### Prerequisites
- Docker Hub account: https://hub.docker.com
- GitHub repository secrets configured

### Setup Steps

#### 1.1 Create Docker Hub Account
```bash
# Visit https://hub.docker.com and sign up
# Create a repository named: devops-springboot-app
```

#### 1.2 Configure GitHub Secrets
Go to: `Settings → Secrets and variables → Actions → New repository secret`

Add these secrets:
- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_PASSWORD`: Your Docker Hub password or access token

#### 1.3 Enable Workflow
The workflow file is at `.github/workflows/deploy-docker-hub.yml`

It will automatically run on:
- Push to main branch
- Creating a tag (e.g., `v1.0.0`)
- Manual trigger

#### 1.4 Pull and Run
```bash
# Pull the image
docker pull shehanfdoking/devops-springboot-app:latest

# Run the container
docker run -d -p 8082:8082 --name devops-app shehanfdoking/devops-springboot-app:latest

# Check logs
docker logs devops-app

# Test the application
curl http://localhost:8082/actuator/health
```

---

## 2. Render Deployment ☁️

Deploy to Render - a modern cloud platform with free tier.

### Prerequisites
- Render account: https://render.com
- GitHub repository connected

### Setup Steps

#### 2.1 Create Render Account
1. Go to https://render.com
2. Sign up with GitHub
3. Authorize Render to access your repositories

#### 2.2 Create Web Service (Option A - Dashboard)
1. Click "New +" → "Web Service"
2. Connect your GitHub repository
3. Configure:
   - **Name**: `devops-springboot-app`
   - **Environment**: `Docker`
   - **Region**: Choose closest to you
   - **Branch**: `main`
   - **Dockerfile Path**: `./Dockerfile`
   - **Health Check Path**: `/actuator/health`
4. Click "Create Web Service"

#### 2.2 Create Web Service (Option B - Blueprint)
1. Push the `render.yaml` file to your repository
2. Render will automatically detect and deploy

#### 2.3 Configure GitHub Actions (Optional)
Get your deploy hook URL:
1. Go to Render Dashboard → Your Service → Settings
2. Copy "Deploy Hook" URL
3. Add to GitHub Secrets as `RENDER_DEPLOY_HOOK_URL`

#### 2.4 Access Your App
```
Your app will be available at:
https://devops-springboot-app.onrender.com

Health check:
https://devops-springboot-app.onrender.com/actuator/health
```

**Note**: Free tier may spin down after inactivity. First request may take 30-60 seconds.

---

## 3. Railway Deployment 🚂

Deploy to Railway - simple and fast cloud deployment.

### Prerequisites
- Railway account: https://railway.app
- Railway CLI (optional)

### Setup Steps

#### 3.1 Create Railway Account
1. Go to https://railway.app
2. Sign up with GitHub
3. Create a new project

#### 3.2 Deploy from GitHub (Option A - Dashboard)
1. Click "New Project"
2. Select "Deploy from GitHub repo"
3. Choose your repository
4. Railway will auto-detect the Dockerfile
5. Add environment variables if needed:
   - `SERVER_PORT`: `8082`
   - `SPRING_PROFILES_ACTIVE`: `production`
6. Deploy!

#### 3.3 Deploy with CLI (Option B - Command Line)
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link to your project
railway link

# Deploy
railway up

# View logs
railway logs
```

#### 3.4 Configure GitHub Actions
1. Get Railway Token:
   - Settings → Tokens → Create Token
2. Add to GitHub Secrets as `RAILWAY_TOKEN`
3. Push to main branch to trigger deployment

#### 3.5 Access Your App
```
Railway provides a URL like:
https://devops-springboot-app-production.up.railway.app

Health check:
https://devops-springboot-app-production.up.railway.app/actuator/health
```

---

## 4. Heroku Deployment 💜

Deploy to Heroku (requires credit card for verification, but offers free tier).

### Setup Steps

#### 4.1 Create Heroku App
```bash
# Install Heroku CLI
# Download from: https://devcenter.heroku.com/articles/heroku-cli

# Login
heroku login

# Create app
heroku create devops-springboot-app

# Set buildpack
heroku buildpacks:set heroku/java
```

#### 4.2 Create Procfile
```bash
# Already included in the project
web: java -jar target/devops-demo-1.0.0.jar
```

#### 4.3 Deploy
```bash
# Add Heroku remote
heroku git:remote -a devops-springboot-app

# Push to Heroku
git push heroku main

# View logs
heroku logs --tail

# Open app
heroku open
```

#### 4.4 Configure GitHub Actions
```bash
# Get Heroku API key
heroku auth:token

# Add to GitHub Secrets:
# HEROKU_API_KEY: your-api-key
# HEROKU_APP_NAME: devops-springboot-app
```

---

## 5. AWS Deployment (Advanced) ☁️

Deploy to AWS EKS (requires AWS account and credentials).

### Prerequisites
- AWS Account
- AWS CLI configured
- kubectl installed
- eksctl installed

### Setup Steps

#### 5.1 Configure AWS Credentials
Add to GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `ECR_REGISTRY`

#### 5.2 Enable AWS Workflows
Rename these files to enable:
```bash
.github/workflows/full-pipeline.yaml.disabled → full-pipeline.yaml
.github/workflows/aws-ecr.yml.disabled → aws-ecr.yml
```

#### 5.3 Follow Detailed Guides
- [AWS ECR Setup](AWS_ECR_SETUP.md)
- [AWS EKS Setup](AWS_EKS_SETUP.md)
- [Full Pipeline Guide](CICD_PIPELINE_GUIDE.md)

---

## Quick Comparison 📊

| Platform | Free Tier | Setup Difficulty | Best For |
|----------|-----------|------------------|----------|
| **Docker Hub** | ✅ Unlimited public images | Easy | Distribution |
| **Render** | ✅ 750 hrs/month | Very Easy | Quick deployment |
| **Railway** | ✅ $5 credit/month | Very Easy | Modern apps |
| **Heroku** | ✅ 550-1000 hrs/month | Easy | Traditional apps |
| **AWS EKS** | ❌ Pay per use | Hard | Production at scale |

---

## Recommended: Render or Railway

For quick deployment with minimal configuration, I recommend **Render** or **Railway**:

### Quick Deploy to Render:
1. Push code to GitHub
2. Go to https://render.com
3. Connect repository
4. Click deploy
5. Done! ✅

### Quick Deploy to Railway:
1. Push code to GitHub
2. Go to https://railway.app
3. New Project → Deploy from GitHub
4. Select repository
5. Done! ✅

---

## Troubleshooting 🔧

### Issue: Deployment fails
```bash
# Check logs
docker logs <container-id>
# or
railway logs
# or
render logs (in dashboard)
```

### Issue: Health check fails
```bash
# Verify endpoint locally first
curl http://localhost:8082/actuator/health

# Check if port is correct (8082)
# Check if application started successfully
```

### Issue: Out of memory
```bash
# Increase memory in platform settings
# Or optimize JVM:
java -Xmx512m -jar app.jar
```

---

## Next Steps 🎯

1. **Choose a platform** from the options above
2. **Configure GitHub Secrets** as needed
3. **Push to main branch** to trigger deployment
4. **Monitor logs** to ensure successful deployment
5. **Test the application** using the provided URL

---

## Support 💬

If you encounter issues:
1. Check platform documentation
2. Review GitHub Actions logs
3. Check application logs in the platform dashboard
4. Verify all secrets are correctly configured

Happy Deploying! 🚀
