# Argo CD - GitOps Guide

## 🎯 What is GitOps?

**GitOps** is a way to do Kubernetes deployments where:
- ✅ Git is the single source of truth
- ✅ Declarative infrastructure and applications
- ✅ Automatic sync from Git to cluster
- ✅ Easy rollbacks (just revert Git commit)
- ✅ Full audit trail

**Argo CD** implements GitOps for Kubernetes.

---

## 🚀 Quick Start

### Step 1: Install Argo CD

```bash
# Create namespace
kubectl create namespace argocd

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods to be ready (2-3 minutes)
kubectl get pods -n argocd -w
```

### Step 2: Access Argo CD UI

```bash
# Port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**Open browser:**
- URL: https://localhost:8080
- Username: `admin`
- Password: (from command above)

⚠️ **Accept self-signed certificate warning**

### Step 3: Install Argo CD CLI (Optional)

**Windows:**
```powershell
choco install argocd-cli -y
```

**Login via CLI:**
```bash
argocd login localhost:8080
# Username: admin
# Password: (same as above)
```

### Step 4: Create Application

```bash
# Apply the application definition
kubectl apply -f argocd/application.yaml

# Or via CLI
argocd app create devops-springboot-app \
  --repo https://github.com/ShehanFdoking/devops-project.git \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated
```

### Step 5: View in UI

Go to https://localhost:8080

You'll see:
- Application card
- Health status
- Sync status
- Resources (Deployments, Pods, Services)

---

## 🎨 Argo CD Features

### 1. Automatic Sync

**When you push to Git:**
1. You commit changes to `k8s/` folder
2. Push to GitHub
3. Argo CD detects change (every 3 minutes)
4. Automatically applies to cluster
5. Shows status in UI

**No manual `kubectl apply` needed!**

### 2. Self-Healing

If someone manually changes the cluster:
```bash
# Manual change
kubectl scale deployment devops-springboot-app --replicas=10
```

Argo CD will:
- Detect drift from Git
- Automatically revert to Git state (3 replicas)
- Keep cluster in sync with Git

### 3. Rollback

**Easy rollbacks:**
```bash
# In Git
git revert HEAD
git push

# Argo CD automatically rolls back!
```

Or in UI:
- Click on application
- Click "History and Rollback"
- Select previous version
- Click "Rollback"

### 4. Multi-Environment

**Different environments from branches:**

```yaml
# Production (main branch)
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-production
spec:
  source:
    repoURL: https://github.com/user/repo.git
    targetRevision: main
    path: k8s/production

# Staging (develop branch)
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-staging
spec:
  source:
    repoURL: https://github.com/user/repo.git
    targetRevision: develop
    path: k8s/staging
```

---

## 📊 Argo CD UI

### Application View

**Tiles show:**
- **App Name**: devops-springboot-app
- **Health**: Healthy/Progressing/Degraded/Suspended
- **Sync Status**: Synced/OutOfSync
- **Last Sync**: Timestamp

### Resource Tree

Click on application to see:
- Deployment (3 replicas)
- ReplicaSet
- Pods (3 running)
- Service (LoadBalancer)
- HPA (if configured)

**Interactive:**
- Click on any resource for details
- View logs
- Describe resource
- Delete resource

### Sync Status

**Synced:**
- ✅ Cluster matches Git
- All green

**OutOfSync:**
- ⚠️ Cluster different from Git
- Shows diff
- Click "Sync" to apply

---

## 🔧 Configuration

### Application Spec

**File:** `argocd/application.yaml`

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devops-springboot-app
  namespace: argocd
spec:
  project: default
  
  source:
    repoURL: https://github.com/ShehanFdoking/devops-project.git
    targetRevision: main  # Branch/tag
    path: k8s             # Folder with manifests
  
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  
  syncPolicy:
    automated:
      prune: true      # Delete removed resources
      selfHeal: true   # Auto-fix manual changes
```

### Sync Options

**Manual Sync:**
```yaml
syncPolicy: {}  # No automated section
```

**Automated with Prune:**
```yaml
syncPolicy:
  automated:
    prune: true  # Delete resources removed from Git
```

**Automated with Self-Heal:**
```yaml
syncPolicy:
  automated:
    selfHeal: true  # Revert manual cluster changes
```

### Ignore Differences

Ignore certain fields (like replicas when using HPA):

```yaml
ignoreDifferences:
  - group: apps
    kind: Deployment
    jsonPointers:
      - /spec/replicas
```

---

## 🎯 GitOps Workflow

### Traditional Workflow

```
Developer → kubectl apply → Kubernetes
```

Problems:
- No audit trail
- Manual process
- Can't see what's deployed
- Hard to rollback

### GitOps Workflow

```
Developer → Git commit → Push
              ↓
         Argo CD detects
              ↓
      Applies to Kubernetes
```

Benefits:
- ✅ Git is source of truth
- ✅ Full audit trail (Git history)
- ✅ Easy rollbacks (Git revert)
- ✅ Declarative
- ✅ Can see exactly what's deployed

---

## 🎨 Advanced Features

### Sync Waves

Control order of resource creation:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  annotations:
    argocd.argoproj.io/sync-wave: "1"  # Create first
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  annotations:
    argocd.argoproj.io/sync-wave: "2"  # Create second
```

### Sync Hooks

Run jobs before/after sync:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
  annotations:
    argocd.argoproj.io/hook: PreSync  # Run before sync
    argocd.argoproj.io/hook-delete-policy: HookSucceeded
```

### Resource Health

Custom health checks:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
spec:
  # ...
  health:
    custom:
      - resource: Deployment
        check: |
          if obj.status.availableReplicas == obj.spec.replicas then
            return {status = "Healthy"}
          end
```

### App of Apps Pattern

One Argo CD application that manages other applications:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: apps
spec:
  source:
    path: argocd/apps  # Folder with app definitions
  syncPolicy:
    automated:
      prune: true
```

---

## 🔐 Security

### RBAC

Control who can sync which apps:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
data:
  policy.csv: |
    p, role:developer, applications, sync, default/*, allow
    p, role:developer, applications, get, default/*, allow
    g, dev-team, role:developer
```

### SSO Integration

Integrate with:
- GitHub
- GitLab
- Google
- Okta
- LDAP

### Encrypted Secrets

Use sealed-secrets or external-secrets:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: my-secret
spec:
  encryptedData:
    password: AgBy3i4OJSWK+PiTySYZZA9rO43cGDEq...
```

---

## 🧪 Testing GitOps

### 1. Make a Change in Git

```bash
# Edit k8s/deployment.yaml
# Change replicas from 3 to 5

git add k8s/deployment.yaml
git commit -m "Scale to 5 replicas"
git push origin main
```

### 2. Watch Argo CD

In Argo CD UI:
1. Wait 3 minutes (auto-refresh)
2. See "OutOfSync" status
3. See "Synced" after Argo CD applies
4. See 5 pods running

### 3. Verify in Kubernetes

```bash
kubectl get pods
# Should see 5 pods
```

### 4. Rollback

```bash
git revert HEAD
git push origin main

# Argo CD automatically scales back to 3
```

---

## 📈 Argo CD vs Traditional CI/CD

### Traditional CI/CD

```
Git Push → CI/CD Pipeline → kubectl apply
```

**Pros:**
- Simple to understand
- Direct control

**Cons:**
- CI/CD needs cluster access
- No drift detection
- Manual rollbacks
- Cluster state can diverge from Git

### Argo CD (GitOps)

```
Git Push → Argo CD detects → Sync to cluster
```

**Pros:**
- ✅ Git is single source of truth
- ✅ Automatic drift correction
- ✅ Easy rollbacks (Git revert)
- ✅ No cluster credentials in CI/CD
- ✅ Multi-cluster management

**Cons:**
- One more tool to learn
- Slightly more complex setup

---

## 🔍 Troubleshooting

### App Shows OutOfSync

1. Click on app in UI
2. Click "App Diff"
3. See what's different
4. Fix in Git or click "Sync"

### Sync Fails

1. Check sync status
2. Click on failed resource
3. View events/logs
4. Fix issue in Git

### Self-Heal Not Working

Check `syncPolicy`:
```yaml
syncPolicy:
  automated:
    selfHeal: true  # Must be true
```

### Can't Access UI

```bash
# Check pods
kubectl get pods -n argocd

# Check service
kubectl get svc -n argocd

# Restart port-forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

---

## 🎓 Best Practices

### 1. Repository Structure

**Option A: Mono-repo**
```
repo/
├── src/              # Application code
├── k8s/              # Kubernetes manifests
└── argocd/           # Argo CD app definitions
```

**Option B: Separate repos**
```
app-repo/             # Application code
gitops-repo/          # Kubernetes manifests
```

### 2. Environment Management

**Separate folders:**
```
k8s/
├── base/             # Common manifests
├── staging/          # Staging overlays
└── production/       # Production overlays
```

**Use Kustomize:**
```yaml
# k8s/production/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
bases:
  - ../base
replicas:
  - name: app
    count: 5
```

### 3. Secret Management

**Never commit secrets to Git!**

Use:
- Sealed Secrets
- External Secrets Operator
- Vault

### 4. Sync Policy

**Start manual, move to automated:**
1. Begin with manual sync
2. Test thoroughly
3. Enable automated
4. Add selfHeal carefully

---

## 📚 Additional Resources

- **Argo CD Docs**: https://argo-cd.readthedocs.io/
- **GitOps Guide**: https://www.gitops.tech/
- **Best Practices**: https://argoproj.github.io/argo-cd/user-guide/best_practices/
- **Examples**: https://github.com/argoproj/argocd-example-apps

---

## ✅ Argo CD Checklist

- [ ] Argo CD installed
- [ ] UI accessible
- [ ] CLI installed (optional)
- [ ] Application created
- [ ] Repository connected
- [ ] Sync working
- [ ] Self-heal tested
- [ ] Rollback tested
- [ ] Understand GitOps workflow

---

**Status:** ✅ GitOps with Argo CD configured!

**Achievement:** 🏆 Complete DevOps pipeline with GitOps!
