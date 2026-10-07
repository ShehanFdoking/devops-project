# SonarQube/SonarCloud Setup Guide

## 🎯 What is SonarQube?

SonarQube is a code quality and security analysis tool that automatically:
- ✅ Detects bugs and code smells
- ✅ Identifies security vulnerabilities
- ✅ Measures code coverage
- ✅ Enforces coding standards
- ✅ Tracks technical debt

We're using **SonarCloud** (cloud-hosted SonarQube) for free integration with GitHub.

---

## 🚀 Quick Setup (SonarCloud)

### Step 1: Sign Up for SonarCloud

1. Go to https://sonarcloud.io
2. Click **"Sign up"**
3. Choose **"Sign up with GitHub"**
4. Authorize SonarCloud to access your GitHub account

### Step 2: Create Organization

1. After login, you'll be prompted to create an organization
2. Choose **"Create a new organization"**
3. Select **"Free plan"** (perfect for public repositories)
4. Organization key: `shehanfdoking` (or your GitHub username)
5. Click **"Continue"**

### Step 3: Import Your Repository

1. Click **"Analyze new project"**
2. Select your repository: `devops-project`
3. Click **"Set Up"**
4. Choose **"With GitHub Actions"**
5. SonarCloud will show you the configuration (we've already added it!)

### Step 4: Generate SonarCloud Token

1. Go to **My Account** → **Security** → **Generate Tokens**
2. Token name: `github-actions-devops-project`
3. Type: **User Token**
4. Expires in: **90 days** (or No expiration)
5. Click **"Generate"**
6. **⚠️ COPY THE TOKEN NOW** - you won't see it again!

### Step 5: Add Token to GitHub Secrets

1. Go to your GitHub repository:
   https://github.com/ShehanFdoking/devops-project

2. Click **Settings** → **Secrets and variables** → **Actions**

3. Click **"New repository secret"**

4. Add the secret:
   - Name: `SONAR_TOKEN`
   - Value: Paste the token you copied
   - Click **"Add secret"**

### Step 6: Push and Watch the Magic! ✨

```bash
# Commit and push (already done, but for future changes)
git add .
git commit -m "Add SonarQube integration"
git push origin main
```

Go to:
- **GitHub Actions**: https://github.com/ShehanFdoking/devops-project/actions
- **SonarCloud Dashboard**: https://sonarcloud.io/project/overview?id=ShehanFdoking_devops-project

---

## 📊 What Gets Analyzed?

### Code Quality Metrics

1. **Bugs** 🐛
   - Potential runtime errors
   - Null pointer exceptions
   - Resource leaks

2. **Vulnerabilities** 🔒
   - Security issues
   - SQL injection risks
   - XSS vulnerabilities

3. **Code Smells** 👃
   - Maintainability issues
   - Complex methods
   - Duplicated code

4. **Coverage** 📈
   - Test coverage percentage
   - Uncovered lines
   - Branch coverage

5. **Duplications** 📋
   - Duplicate code blocks
   - Copy-paste issues

### Quality Gates

SonarCloud will **fail** your build if:
- ❌ New bugs are introduced
- ❌ Security vulnerabilities found
- ❌ Code coverage drops below threshold
- ❌ Code duplication is too high
- ❌ Too many code smells

---

## 🔧 Configuration Files

### 1. `pom.xml` - Maven Configuration

Added plugins:
```xml
<!-- JaCoCo for code coverage -->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
</plugin>

<!-- SonarQube Scanner -->
<plugin>
    <groupId>org.sonarsource.scanner.maven</groupId>
    <artifactId>sonar-maven-plugin</artifactId>
</plugin>
```

### 2. `sonar-project.properties` - SonarCloud Settings

Key configurations:
- Project key and organization
- Source and test directories
- Java version
- Coverage report location
- File exclusions

### 3. `.github/workflows/ci.yml` - Updated CI Pipeline

New steps added:
- Run tests with JaCoCo coverage
- Upload coverage reports
- Run SonarCloud scan
- Cache SonarCloud packages

---

## 🧪 Running SonarQube Locally

### Option 1: Run Analysis Locally (requires SonarCloud)

```bash
# Set your token as environment variable
export SONAR_TOKEN=your_token_here

# Run Maven with Sonar
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=ShehanFdoking_devops-project \
  -Dsonar.organization=shehanfdoking \
  -Dsonar.host.url=https://sonarcloud.io
```

### Option 2: Local SonarQube Server (Docker)

```bash
# Start SonarQube server
docker run -d --name sonarqube \
  -p 9000:9000 \
  sonarqube:latest

# Wait for startup (2-3 minutes)
# Access: http://localhost:9000
# Default credentials: admin/admin

# Run analysis against local server
mvn clean verify sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your_token
```

---

## 📈 Reading SonarCloud Reports

### Dashboard Overview

After your first scan, you'll see:

```
┌─────────────────────────────────────────┐
│  Bugs: 0        Security: 0             │
│  Vulnerabilities: 0    Code Smells: 2   │
│  Coverage: 85%         Duplications: 0% │
└─────────────────────────────────────────┘
```

### Quality Gate Status

- ✅ **Passed**: Code meets quality standards
- ❌ **Failed**: Issues detected, fix before merging

### Severity Levels

- 🔴 **Blocker**: Must fix immediately
- 🟠 **Critical**: High priority
- 🟡 **Major**: Medium priority
- 🔵 **Minor**: Low priority
- ⚪ **Info**: Informational

---

## 🎨 Customizing Quality Rules

### 1. Add Quality Gate Badge to README

Add this to your README.md:

```markdown
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ShehanFdoking_devops-project&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=ShehanFdoking_devops-project)

[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=ShehanFdoking_devops-project&metric=bugs)](https://sonarcloud.io/summary/new_code?id=ShehanFdoking_devops-project)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=ShehanFdoking_devops-project&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=ShehanFdoking_devops-project)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=ShehanFdoking_devops-project&metric=coverage)](https://sonarcloud.io/summary/new_code?id=ShehanFdoking_devops-project)
```

### 2. Configure Quality Gate Thresholds

In SonarCloud:
1. Go to **Project Settings** → **Quality Gate**
2. Choose or create a quality gate
3. Set thresholds:
   - Coverage: > 80%
   - Duplications: < 3%
   - Maintainability Rating: A

### 3. Exclude Files from Analysis

Edit `sonar-project.properties`:
```properties
sonar.exclusions=**/target/**,**/*.xml,**/generated/**
```

---

## 🔍 Common Issues and Solutions

### Issue 1: "SONAR_TOKEN not found"
**Solution:** Make sure you added `SONAR_TOKEN` to GitHub Secrets (Step 5 above)

### Issue 2: "Shallow clone detected"
**Solution:** Already fixed with `fetch-depth: 0` in workflow

### Issue 3: "Project not found in SonarCloud"
**Solution:** Ensure project key matches in:
- `pom.xml` properties
- `sonar-project.properties`
- GitHub Actions workflow

### Issue 4: Coverage reports not showing
**Solution:** Run tests before sonar scan:
```bash
mvn clean test jacoco:report sonar:sonar
```

### Issue 5: Analysis takes too long
**Solution:** Enable SonarCloud package caching (already configured)

---

## 📚 Understanding the Reports

### Code Coverage Example

```java
// ✅ Covered by tests (green)
@Test
public void testHelloEndpoint() {
    // This code is executed during tests
}

// ❌ Not covered by tests (red)
public void unusedMethod() {
    // This code is never executed in tests
}
```

### Bug Detection Example

```java
// ❌ Bug: Null pointer risk
String name = getName();
return name.toUpperCase(); // What if getName() returns null?

// ✅ Fixed
String name = getName();
return name != null ? name.toUpperCase() : "";
```

### Code Smell Example

```java
// ❌ Code Smell: Too complex
public void processOrder(Order order) {
    if (order != null) {
        if (order.getItems() != null) {
            if (order.getItems().size() > 0) {
                // Nested complexity
            }
        }
    }
}

// ✅ Better
public void processOrder(Order order) {
    if (order == null || order.getItems() == null || order.getItems().isEmpty()) {
        return;
    }
    // Clear, readable code
}
```

---

## 🎓 Best Practices

1. **Run locally before pushing**
   ```bash
   mvn clean verify sonar:sonar -Dsonar.login=$SONAR_TOKEN
   ```

2. **Fix blockers and critical issues first**
   - Focus on high-severity issues
   - Ignore minor code smells temporarily

3. **Improve test coverage gradually**
   - Aim for 80%+ coverage
   - Focus on business logic

4. **Use SonarLint IDE plugin**
   - Real-time feedback while coding
   - Available for IntelliJ, VS Code, Eclipse

5. **Review new code only**
   - SonarCloud focuses on new/changed code
   - Don't try to fix all legacy issues at once

---

## 📊 Integration with PR Reviews

SonarCloud will automatically:
- ✅ Comment on Pull Requests with issues
- ✅ Show quality gate status
- ✅ Block merge if quality gate fails (optional)
- ✅ Highlight new issues in your changes

---

## 🔗 Useful Links

- **Your SonarCloud Project**: https://sonarcloud.io/project/overview?id=ShehanFdoking_devops-project
- **SonarCloud Documentation**: https://docs.sonarcloud.io/
- **SonarQube Rules**: https://rules.sonarsource.com/java
- **JaCoCo Documentation**: https://www.jacoco.org/jacoco/trunk/doc/

---

## ✅ Verification Checklist

Before moving to the next step, verify:

- [ ] SonarCloud account created
- [ ] Organization set up
- [ ] Project imported
- [ ] `SONAR_TOKEN` added to GitHub Secrets
- [ ] Pushed code triggers SonarCloud analysis
- [ ] Can view results in SonarCloud dashboard
- [ ] Quality gate status shows in GitHub Actions
- [ ] Coverage reports are generated

---

**Status:** ✅ SonarQube integration is now configured!

**Next Step:** AWS ECR - Push your Docker images to Amazon Elastic Container Registry
