# GitHub Actions CI/CD Setup Guide

## 🎯 What We've Built

Your repository now has **two automated workflows** that will run automatically whenever you push code:

### 1. **CI Pipeline** (`.github/workflows/ci.yml`)
**Triggers:** Every push to `main` or `develop` branches, and all Pull Requests

**What it does:**
```
Push Code → Build with Maven → Run Tests → Build Docker Image → Test Docker Image
```

**Steps in detail:**
- ✅ Checks out your code
- ✅ Sets up Java 17
- ✅ Builds with Maven (caching dependencies for speed)
- ✅ Runs unit tests
- ✅ Saves JAR artifact (available for 7 days)
- ✅ Builds Docker image
- ✅ Tests Docker image by:
  - Running container on port 8082
  - Testing `/api/hello` endpoint
  - Testing `/actuator/health` endpoint

### 2. **Docker Publish Pipeline** (`.github/workflows/docker-publish.yml`)
**Triggers:** Push to `main`, version tags (v*.*.*), or manual dispatch

**What it does:**
```
Push to Main → Build & Test → Login to Docker Hub → Build Docker Image → Push to Docker Hub
```

**Tags created:**
- `latest` (for main branch)
- `main-<commit-sha>` (unique identifier)
- `v1.0.0` (if you create a git tag)
- `1.0` (major.minor version)

---

## 🚀 Quick Start

### View Your CI/CD in Action

1. Go to your GitHub repository: https://github.com/ShehanFdoking/devops-project

2. Click on the **"Actions"** tab

3. You should see the workflows running now! (triggered by our recent push)

4. Click on any workflow run to see:
   - Build logs
   - Test results
   - Docker build output
   - Success/failure status

---

## 🐳 Setting Up Docker Hub Publishing (Optional but Recommended)

To automatically push Docker images to Docker Hub:

### Step 1: Create Docker Hub Account
1. Go to https://hub.docker.com
2. Sign up for a free account
3. Verify your email

### Step 2: Generate Access Token
1. Log in to Docker Hub
2. Click on your username → **Account Settings**
3. Go to **Security** → **New Access Token**
4. Give it a name: `github-actions`
5. Set permissions: **Read, Write, Delete**
6. Click **Generate**
7. **⚠️ COPY THE TOKEN NOW** - you won't see it again!

### Step 3: Add Secrets to GitHub
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add two secrets:

   **Secret 1:**
   - Name: `DOCKERHUB_USERNAME`
   - Value: Your Docker Hub username (e.g., `shehanfdoking`)

   **Secret 2:**
   - Name: `DOCKERHUB_TOKEN`
   - Value: The access token you copied

### Step 4: Test It!
1. Make any small change to your code
2. Commit and push:
   ```bash
   git add .
   git commit -m "Test Docker Hub publishing"
   git push origin main
   ```
3. Go to Actions tab and watch the `docker-publish` workflow
4. Check your Docker Hub account - your image should appear!

---

## 📊 Understanding the Workflows

### Workflow Triggers

| Event | ci.yml | docker-publish.yml |
|-------|--------|-------------------|
| Push to `main` | ✅ | ✅ |
| Push to `develop` | ✅ | ❌ |
| Pull Request | ✅ | ❌ |
| Git Tag (v1.0.0) | ❌ | ✅ |
| Manual | ❌ | ✅ |

### Job Dependencies

```
ci.yml:
  build-and-test → docker-build
  
docker-publish.yml:
  All steps in one job (sequential)
```

### Caching Strategy

Both workflows use caching to speed up builds:
- **Maven dependencies** cached by GitHub Actions
- **Docker layers** cached using GitHub Actions cache
- **Result:** First build ~5-8 minutes, subsequent builds ~2-3 minutes

---

## 🧪 Testing Your Setup

### Test 1: Break the Build
1. Edit `HelloController.java` and introduce a syntax error
2. Commit and push
3. Watch GitHub Actions fail (this is good!)
4. Fix the error and push again
5. Watch it pass ✅

### Test 2: Create a Release
1. Create a git tag:
   ```bash
   git tag -a v1.0.0 -m "First release"
   git push origin v1.0.0
   ```
2. Watch `docker-publish` workflow create versioned images
3. Check Docker Hub for tags: `v1.0.0`, `1.0`, `latest`

### Test 3: Manual Workflow Dispatch
1. Go to Actions tab
2. Select `Docker Build and Push`
3. Click `Run workflow`
4. Select branch and run
5. Watch it execute on demand

---

## 🎨 Customizing Your Workflows

### Add Code Coverage
Add to `ci.yml` after tests:
```yaml
- name: Generate code coverage
  run: mvn jacoco:report
  
- name: Upload coverage reports
  uses: codecov/codecov-action@v3
```

### Add Slack Notifications
Add at the end of jobs:
```yaml
- name: Notify Slack
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Change Build Triggers
Modify the `on:` section:
```yaml
on:
  push:
    branches: [ main, develop, feature/* ]
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
```

---

## 🔍 Troubleshooting

### Workflow Fails with "Docker Hub Login Failed"
- ✅ Check `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets exist
- ✅ Verify token has not expired
- ✅ Ensure token has Read & Write permissions

### Tests Fail in CI but Pass Locally
- ✅ Check Java version match (both should be 17)
- ✅ Look for environment-specific issues
- ✅ Review GitHub Actions logs for detailed errors

### Docker Build is Slow
- ✅ Ensure cache is enabled (it is by default)
- ✅ Check if `.dockerignore` is properly configured
- ✅ First build is always slower (nothing cached yet)

### Can't See Actions Tab
- ✅ Repository must be on GitHub (not just local)
- ✅ Workflows must be in `.github/workflows/` directory
- ✅ Files must have `.yml` or `.yaml` extension

---

## 📈 What's Next?

Now that you have CI/CD running, you can:

1. **Step 6: SonarQube** - Add code quality checks to your pipeline
2. **Step 7: AWS ECR** - Push images to Amazon's container registry
3. **Step 8: Kubernetes** - Deploy your container to K8s
4. **Monitor & Alert** - Add notifications for build failures

---

## 🎓 Key Concepts Learned

✅ **Continuous Integration (CI)**: Automatically build and test on every commit  
✅ **Continuous Delivery (CD)**: Automatically create deployable artifacts  
✅ **Pipeline as Code**: Workflows defined in YAML, version controlled  
✅ **Secrets Management**: Secure credential storage in GitHub  
✅ **Docker Layer Caching**: Speed up builds with intelligent caching  
✅ **Multi-stage Builds**: Separate build and runtime environments  

---

## 📚 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Actions](https://github.com/marketplace/actions/build-and-push-docker-images)
- [Maven GitHub Actions](https://github.com/actions/setup-java)
- [Your Workflows](https://github.com/ShehanFdoking/devops-project/actions)

---

**Status:** ✅ GitHub Actions CI/CD is now fully configured and running!
