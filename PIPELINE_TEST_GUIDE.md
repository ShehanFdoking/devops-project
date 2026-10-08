# 🚀 CI/CD Pipeline Test - Live Execution Guide

## What We Just Did

We made the following changes to test the full CI/CD pipeline:

### Code Changes
1. **Updated HelloController.java**
   - Version: `1.0` → `2.0`
   - Message: "Hello from DevOps!" → "Hello from DevOps CI/CD Pipeline!"
   - Added fields: `pipeline` and `status`

2. **Updated HelloControllerTest.java**
   - Updated test assertions to match new response structure
   - Tests passed locally ✅

3. **Committed and Pushed**
   - Commit: `47fcef8`
   - Branch: `main`
   - Trigger: Push to main → Full pipeline execution

---

## 📊 Watch the Pipeline Execute

### 1. GitHub Actions Dashboard

**Go to:** https://github.com/ShehanFdoking/devops-project/actions

You'll see:
- 🟡 **Yellow dot** = Pipeline running
- ✅ **Green checkmark** = Stage completed
- ❌ **Red X** = Stage failed

### 2. Pipeline Stages to Monitor

Watch these stages execute in order:

#### Stage 1: Build & Test (2-3 min)
```
✅ Checkout code
✅ Set up JDK 17
✅ Generate version (YYYYMMDD-47fcef8)
✅ Build with Maven
✅ Run unit tests
✅ Upload JAR artifact
```

#### Stage 2: Code Quality (2-3 min)
```
✅ Checkout code
✅ Run tests with JaCoCo coverage
✅ SonarCloud Scan
⚠️  Quality Gate check (may show warning)
```

#### Stage 3: Security Scan (1 min)
```
✅ Trivy vulnerability scanner
✅ Upload results to GitHub Security
```

#### Stage 4: Build Docker (3-5 min)
```
✅ Docker Buildx setup
✅ AWS credentials configuration
✅ Login to ECR
✅ Build and tag image
✅ Push to ECR with version
✅ Scan image with Trivy
```

#### Stage 5: Deploy Staging (Skipped)
```
⏭️  Skipped (only runs on 'develop' branch)
```

#### Stage 6: Deploy Production (2-3 min)
```
⚠️  This will FAIL if EKS cluster doesn't exist
   (Expected - we didn't deploy EKS to avoid costs)
```

**Expected Behavior:**
- Pipeline will succeed through Docker Build
- Production deployment will fail (no EKS cluster)
- This is NORMAL and expected! ✅

---

## 🎯 What to Check

### 1. View Workflow Run

Click on the latest workflow run:
- **Name:** "Test full CI/CD pipeline - Update API to v2.0 with enhanced response"
- **Branch:** main
- **SHA:** 47fcef8

### 2. Check Individual Jobs

Click on each job to see:
- Real-time logs
- Step execution
- Test results
- Artifacts

### 3. View SonarCloud Analysis

**Go to:** https://sonarcloud.io/project/overview?id=ShehanFdoking_devops-project

You'll see:
- Code coverage updated
- New code analysis
- Quality gate status
- Bugs, vulnerabilities, code smells

### 4. Check ECR Repository

**Go to AWS Console:**
```
https://console.aws.amazon.com/ecr/repositories/devops-springboot-app
```

You should see new image tags:
- `20261008-47fcef8` (version tag)
- `latest` (updated)

### 5. View GitHub Security Tab

**Go to:** https://github.com/ShehanFdoking/devops-project/security

Check:
- Dependabot alerts
- Trivy scan results
- Security overview

---

## 📈 Expected Timeline

```
00:00 - Push detected
00:30 - Build & Test starts
03:00 - Code Quality starts
05:30 - Security Scan starts
06:30 - Docker Build starts
11:00 - Deploy Production starts
13:00 - ❌ Deploy fails (no EKS)
```

**Total Time:** ~13-15 minutes (until deployment failure)

---

## ✅ Success Criteria

Even though deployment will fail, the pipeline is successful if:

1. ✅ **Build & Test** - All tests pass
2. ✅ **Code Quality** - SonarCloud analysis completes
3. ✅ **Security Scan** - No critical vulnerabilities blocking
4. ✅ **Docker Build** - Image pushed to ECR successfully

**Deployment failure is expected** because:
- We don't have an EKS cluster running
- This avoids AWS costs (~$155/month)
- The image is still available in ECR for manual deployment

---

## 🧪 Verify the Changes

### Option 1: Test Locally

```bash
# Build new image
docker build -t devops-springboot-app:2.0 .

# Run container
docker run -d -p 8082:8082 --name devops-app-v2 devops-springboot-app:2.0

# Test API
curl http://localhost:8082/api/hello
```

**Expected Response:**
```json
{
  "message": "Hello from DevOps CI/CD Pipeline!",
  "version": "2.0",
  "pipeline": "Full CI/CD with GitHub Actions",
  "status": "All 13 steps completed!"
}
```

### Option 2: Pull from ECR (after pipeline completes)

```bash
# Login to ECR
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 852093845150.dkr.ecr.eu-north-1.amazonaws.com

# Pull new image
docker pull 852093845150.dkr.ecr.eu-north-1.amazonaws.com/devops-springboot-app:latest

# Run container
docker run -d -p 8082:8082 --name devops-app-ecr 852093845150.dkr.ecr.eu-north-1.amazonaws.com/devops-springboot-app:latest

# Test API
curl http://localhost:8082/api/hello
```

---

## 🔍 Troubleshooting

### Pipeline Not Starting?

1. Check repository settings: Settings → Actions → General
2. Ensure "Actions permissions" is enabled
3. Verify workflow file is in `.github/workflows/`

### Build Fails?

1. Check test logs
2. Verify Java 17 compatibility
3. Check Maven dependencies

### SonarCloud Fails?

1. Check `SONAR_TOKEN` secret exists
2. Verify project key matches in `sonar-project.properties`
3. Check SonarCloud service status

### Docker Build Fails?

1. Check AWS credentials are valid
2. Verify ECR repository exists
3. Check IAM permissions for ECR push

---

## 🎓 What You're Learning

By watching this pipeline, you'll see:

1. **Automation** - No manual steps required
2. **Parallel Execution** - Multiple jobs run simultaneously
3. **Quality Gates** - Automated checks at each stage
4. **Artifact Management** - JAR and Docker images stored
5. **Security** - Automated vulnerability scanning
6. **Observability** - Full visibility into each step

---

## 📚 Next Steps

After the pipeline completes:

1. **Review the execution logs** - Learn what each step does
2. **Check SonarCloud report** - See code quality metrics
3. **View ECR images** - Confirm Docker image pushed
4. **Test locally** - Pull and run the new version
5. **Try breaking it** - Introduce a test failure, see what happens
6. **Add more tests** - Improve code coverage
7. **Deploy to EKS** - When ready to pay for infrastructure

---

## 🎉 Success Metrics

**You'll know the test was successful when:**

✅ All stages complete (except deployment)
✅ New Docker image in ECR
✅ SonarCloud shows updated analysis
✅ GitHub Security tab shows scan results
✅ You can pull and run the new version locally

---

**Status:** 🚀 Pipeline triggered and running!

**Live Dashboard:** https://github.com/ShehanFdoking/devops-project/actions

**Estimated Completion:** ~15 minutes
