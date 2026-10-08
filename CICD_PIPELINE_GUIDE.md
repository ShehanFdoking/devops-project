# Complete CI/CD Pipeline Guide

## 🎯 What is CI/CD?

**Continuous Integration (CI):**
- Automatically build and test code on every commit
- Catch bugs early
- Ensure code quality

**Continuous Delivery/Deployment (CD):**
- Automatically deploy to staging/production
- Reduce manual errors
- Fast, reliable releases

---

## 🚀 Our Complete Pipeline

### Pipeline Stages

```
1. Code Push
   ↓
2. Build & Test (Maven)
   ↓
3. Code Quality (SonarCloud)
   ↓
4. Security Scan (Trivy)
   ↓
5. Docker Build & Push (ECR)
   ↓
6. Deploy to Staging (optional)
   ↓
7. Deploy to Production
   ↓
8. Smoke Tests
   ↓
9. Notifications
```

### Workflow Files

1. **`full-pipeline.yaml`** - Complete integrated pipeline
2. **`ci.yml`** - Build, test, Docker (existing)
3. **`docker-publish.yml`** - Docker Hub publishing (existing)
4. **`aws-ecr.yml`** - AWS ECR deployment (existing)

---

## 📊 Full Pipeline Features

### Stage 1: Build & Test
- ✅ Java 17 with Maven
- ✅ Run unit tests
- ✅ Generate version number
- ✅ Upload artifacts (JAR, test reports)

### Stage 2: Code Quality
- ✅ SonarCloud analysis
- ✅ Code coverage (JaCoCo)
- ✅ Quality gate check
- ✅ Code smells detection

### Stage 3: Security Scanning
- ✅ Trivy filesystem scan
- ✅ Dependency vulnerabilities
- ✅ Upload to GitHub Security
- ✅ Block on critical issues (optional)

### Stage 4: Docker Build
- ✅ Multi-stage build
- ✅ Push to ECR with version tags
- ✅ Container image scanning
- ✅ Automatic latest tag

### Stage 5: Deploy Staging (develop branch)
- ✅ Deploy to staging namespace
- ✅ Automatic rollback on failure
- ✅ Environment protection rules

### Stage 6: Deploy Production (main branch)
- ✅ Deploy to production namespace
- ✅ Rolling update strategy
- ✅ Zero-downtime deployment
- ✅ Environment approvals (optional)

### Stage 7: Verification
- ✅ Smoke tests (health + API)
- ✅ Rollout status check
- ✅ Pod health verification

### Stage 8: Notifications
- ✅ Deployment summary
- ✅ Status badges
- ✅ GitHub summary page

---

## 🔧 Setup Instructions

### 1. GitHub Environments

Create two environments in GitHub:
- **staging** - For develop branch
- **production** - For main branch (with required reviewers)

**Steps:**
1. Go to: https://github.com/ShehanFdoking/devops-project/settings/environments
2. Click "New environment"
3. Name: `production`
4. Add protection rules:
   - Required reviewers: (select yourself)
   - Wait timer: 0 minutes
5. Repeat for `staging`

### 2. Required Secrets

Add these secrets in GitHub:
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `SONAR_TOKEN` - SonarCloud token
- `ECR_REGISTRY` - Your ECR registry URL

### 3. Update Workflow

Edit `full-pipeline.yaml`:

```yaml
env:
  AWS_REGION: eu-north-1          # Your region
  ECR_REPOSITORY: devops-springboot-app
  EKS_CLUSTER_NAME: devops-cluster
  K8S_NAMESPACE: default
```

---

## 🎮 Using the Pipeline

### Automatic Triggers

**Push to `main`:**
```bash
git push origin main
```
→ Triggers: Full pipeline → Production deployment

**Push to `develop`:**
```bash
git push origin develop
```
→ Triggers: Full pipeline → Staging deployment

**Pull Request:**
```bash
# Create PR to main
```
→ Triggers: Build, test, quality checks (no deployment)

### Manual Trigger

Go to: https://github.com/ShehanFdoking/devops-project/actions

1. Select "Full CI/CD Pipeline"
2. Click "Run workflow"
3. Select branch
4. Click "Run workflow"

---

## 📊 Pipeline Execution Flow

### Success Flow

```
✅ Build & Test (2-3 min)
   ↓
✅ Code Quality (2-3 min)
   ↓
✅ Security Scan (1 min)
   ↓
✅ Docker Build (3-5 min)
   ↓
✅ Deploy Production (2-3 min)
   ↓
✅ Verification (30 sec)
   ↓
🎉 Success!
```

**Total Time:** ~10-15 minutes

### Failure Handling

**If test fails:**
- ❌ Pipeline stops at Build & Test
- No deployment happens
- Fix tests, push again

**If quality gate fails:**
- ⚠️  Warning shown (continues by default)
- Review SonarCloud report
- Fix issues in next commit

**If deployment fails:**
- ❌ Pipeline stops
- Kubernetes keeps previous version running
- No downtime!
- Check logs, fix issue, retry

---

## 🔍 Monitoring Pipeline

### View Pipeline Status

**GitHub Actions Tab:**
https://github.com/ShehanFdoking/devops-project/actions

Shows:
- ✅ Running workflows
- ✅ Success/failure status
- ✅ Execution logs
- ✅ Artifacts

### Logs and Debugging

Click on workflow run → Click on failed job → View logs

**Common issues:**
- AWS credentials expired
- EKS cluster not accessible
- Docker build failed
- Tests failed

---

## 🎨 Advanced Features

### Deployment Strategies

**Current:** Rolling Update
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

**Alternative: Blue-Green**
```yaml
# Deploy new version alongside old
# Switch traffic when ready
# Keep old version for rollback
```

**Alternative: Canary**
```yaml
# Deploy to 10% of pods
# Monitor metrics
# Gradually increase to 100%
```

### Rollback

**Automatic rollback on failure:**
Already configured! Kubernetes keeps previous ReplicaSet.

**Manual rollback:**
```bash
kubectl rollout undo deployment/devops-springboot-app
```

**Rollback to specific version:**
```bash
kubectl rollout history deployment/devops-springboot-app
kubectl rollout undo deployment/devops-springboot-app --to-revision=2
```

---

## 📈 Pipeline Metrics

### Success Rate

Track:
- Successful deployments / Total deployments
- Mean Time To Recovery (MTTR)
- Deployment frequency
- Lead time for changes

### Performance

**Target metrics:**
- Build time: <5 minutes
- Deploy time: <3 minutes
- Total pipeline: <15 minutes
- Success rate: >95%

---

## 🔔 Notifications

### Add Slack Notifications

Add this step to `notify` job:

```yaml
- name: Slack Notification
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Deployment to production ${{ job.status }}'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
  if: always()
```

### Add Email Notifications

GitHub sends email by default for:
- Workflow failures
- @mentions in comments

Configure in: https://github.com/settings/notifications

---

## 🧪 Testing the Pipeline

### 1. Make a Small Change

```bash
# Edit HelloController.java
# Change message to "Hello from CI/CD!"

git add .
git commit -m "Test CI/CD pipeline"
git push origin main
```

### 2. Watch Pipeline Execute

Go to Actions tab, see:
- Build & Test running
- Code Quality analysis
- Docker image building
- Production deployment

### 3. Verify Deployment

```bash
# Check pods updated
kubectl get pods

# Test application
curl http://your-load-balancer/api/hello
```

---

## 🎓 Best Practices

### 1. Fast Feedback
- ✅ Run fast tests first
- ✅ Fail fast on critical issues
- ✅ Parallel job execution

### 2. Security
- ✅ Scan code and images
- ✅ Use secrets management
- ✅ Rotate credentials regularly

### 3. Reliability
- ✅ Automated tests (unit, integration)
- ✅ Smoke tests after deployment
- ✅ Automatic rollback

### 4. Visibility
- ✅ Clear pipeline stages
- ✅ Detailed logs
- ✅ Status badges

### 5. Speed
- ✅ Cache dependencies
- ✅ Incremental builds
- ✅ Parallel execution

---

## 🔗 Related Documentation

- **GitHub Actions**: [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)
- **Kubernetes**: [KUBERNETES_SETUP.md](KUBERNETES_SETUP.md)
- **AWS EKS**: [AWS_EKS_SETUP.md](AWS_EKS_SETUP.md)
- **Monitoring**: [MONITORING_GUIDE.md](MONITORING_GUIDE.md)

---

## ✅ Pipeline Checklist

- [ ] GitHub environments configured
- [ ] All secrets added
- [ ] EKS cluster accessible
- [ ] ECR repository exists
- [ ] Application deployed manually once
- [ ] Smoke tests passing
- [ ] Pipeline executed successfully
- [ ] Rollback tested

---

**Status:** ✅ Complete CI/CD pipeline configured!

**Next:** Add GitOps with Argo CD for declarative deployments!
