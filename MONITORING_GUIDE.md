# Monitoring with Prometheus & Grafana

## 🎯 What is Prometheus & Grafana?

**Prometheus:**
- Time-series database for metrics
- Scrapes metrics from applications
- Powerful query language (PromQL)
- Built-in alerting

**Grafana:**
- Visualization and dashboarding
- Beautiful, customizable graphs
- Alert management
- Multiple data source support

**Together they provide:** Complete observability for your application! 📊

---

## 🚀 Quick Start (Local Kubernetes)

### Prerequisites

- Kubernetes cluster running (Docker Desktop K8s)
- Helm installed
- kubectl configured

### Step 1: Install Helm (if not installed)

**Windows:**
```powershell
choco install kubernetes-helm -y
```

**Verify:**
```bash
helm version
```

### Step 2: Add Prometheus Helm Repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### Step 3: Install Prometheus Stack

```bash
# Create monitoring namespace
kubectl create namespace monitoring

# Install Prometheus + Grafana
helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f monitoring/prometheus/values.yaml

# Wait for pods to be ready (2-3 minutes)
kubectl get pods -n monitoring -w
```

### Step 4: Deploy Application with Prometheus Annotations

```bash
# Apply updated deployment
kubectl apply -f k8s/deployment.yaml

# Apply ServiceMonitor
kubectl apply -f monitoring/servicemonitor.yaml

# Apply alerts
kubectl apply -f monitoring/alerts.yaml
```

### Step 5: Access Grafana

**Port forward:**
```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

**Open browser:**
- URL: http://localhost:3000
- Username: `admin`
- Password: `admin123` (change in production!)

### Step 6: View Dashboards

In Grafana:
1. Go to **Dashboards** → **Browse**
2. Open **Spring Boot 2.x** dashboard
3. See your application metrics! 🎉

---

## 📊 What Gets Monitored?

### Application Metrics

**HTTP Requests:**
- Request rate (req/sec)
- Response time (p50, p95, p99)
- Error rate (4xx, 5xx)
- Active requests

**JVM Metrics:**
- Heap memory usage
- Non-heap memory usage
- GC pause time
- Thread count
- CPU usage

**Custom Metrics:**
- Business metrics (order count, user count, etc.)
- Database queries
- Cache hit rate
- External API calls

### Kubernetes Metrics

**Pod Metrics:**
- CPU usage
- Memory usage
- Network I/O
- Restart count

**Node Metrics:**
- CPU utilization
- Memory utilization
- Disk usage
- Network traffic

**Cluster Metrics:**
- Node count
- Pod count
- Resource requests/limits
- Namespace usage

---

## 🎨 Pre-configured Dashboards

We've configured 4 professional dashboards:

### 1. Spring Boot 2.x Dashboard (ID: 12900)
- HTTP request metrics
- JVM memory and GC
- Tomcat metrics
- Spring MVC statistics

### 2. JVM Micrometer Dashboard (ID: 4701)
- Detailed JVM internals
- Memory pools
- Class loading
- Thread states

### 3. Kubernetes Cluster Monitoring (ID: 7249)
- Cluster overview
- Node metrics
- Pod health
- Resource usage

### 4. Node Exporter Full (ID: 1860)
- CPU usage per node
- Memory details
- Disk I/O
- Network statistics

---

## 🔔 Alerts Configured

### Critical Alerts

**ApplicationDown:**
- Triggers when app stops responding
- Fires after 2 minutes
- Severity: Critical

### Warning Alerts

**HighCPUUsage:**
- Triggers at >80% CPU
- Fires after 5 minutes

**HighMemoryUsage:**
- Triggers at >90% heap
- Fires after 5 minutes

**HighErrorRate:**
- Triggers at >10% errors
- Fires after 5 minutes

**SlowResponseTime:**
- Triggers when p95 >1 second
- Fires after 10 minutes

**PodRestarting:**
- Triggers on frequent restarts
- Fires after 5 minutes

**LowDiskSpace:**
- Triggers at <10% free
- Fires after 5 minutes

---

## 🧪 Testing Your Monitoring

### 1. Generate Some Traffic

```bash
# Get service URL
export APP_URL=$(kubectl get svc devops-springboot-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Or use localhost if running locally
export APP_URL="localhost"

# Generate requests
for i in {1..1000}; do
  curl http://$APP_URL/api/hello
  sleep 0.1
done
```

### 2. View Metrics in Grafana

1. Open Grafana (http://localhost:3000)
2. Go to **Spring Boot 2.x** dashboard
3. See requests appearing in real-time!

### 3. Check Prometheus Targets

```bash
# Port forward Prometheus
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

# Open http://localhost:9090
# Go to Status → Targets
# Verify spring-boot-app target is UP
```

### 4. Query Metrics Directly

In Prometheus UI (http://localhost:9090):

```promql
# Request rate
rate(http_server_requests_seconds_count[5m])

# Memory usage
jvm_memory_used_bytes{area="heap"}

# CPU usage
process_cpu_usage

# Error rate
rate(http_server_requests_seconds_count{status=~"5.."}[5m])
```

---

## 📈 PromQL Examples

### HTTP Metrics

```promql
# Total request rate
sum(rate(http_server_requests_seconds_count[5m]))

# Request rate by endpoint
sum(rate(http_server_requests_seconds_count[5m])) by (uri)

# P95 response time
histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket[5m])) by (le))

# Error rate percentage
sum(rate(http_server_requests_seconds_count{status=~"5.."}[5m])) / sum(rate(http_server_requests_seconds_count[5m])) * 100
```

### JVM Metrics

```promql
# Heap memory usage percentage
jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"} * 100

# GC pause time
rate(jvm_gc_pause_seconds_sum[5m])

# Thread count
jvm_threads_live_threads
```

### Kubernetes Metrics

```promql
# Pod CPU usage
sum(rate(container_cpu_usage_seconds_total{pod=~"devops-springboot-app.*"}[5m])) by (pod)

# Pod memory usage
sum(container_memory_working_set_bytes{pod=~"devops-springboot-app.*"}) by (pod)

# Pod restart count
kube_pod_container_status_restarts_total{pod=~"devops-springboot-app.*"}
```

---

## 🎨 Creating Custom Dashboards

### In Grafana:

1. Click **+** → **Dashboard** → **Add new panel**
2. Enter PromQL query
3. Choose visualization type (graph, gauge, table)
4. Configure axes, colors, thresholds
5. **Save dashboard**

### Example Panel:

**Title:** Request Rate  
**Query:** `sum(rate(http_server_requests_seconds_count[5m]))`  
**Visualization:** Graph  
**Unit:** requests/sec

---

## 🔔 Configuring Notifications

### Slack Notifications

Edit `monitoring/prometheus/values.yaml`:

```yaml
alertmanager:
  config:
    receivers:
      - name: 'slack'
        slack_configs:
          - api_url: 'YOUR_SLACK_WEBHOOK_URL'
            channel: '#alerts'
            title: '{{ .GroupLabels.alertname }}'
            text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

### Email Notifications

```yaml
receivers:
  - name: 'email'
    email_configs:
      - to: 'team@company.com'
        from: 'alerts@company.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'alerts@company.com'
        auth_password: 'your-password'
```

### PagerDuty Integration

```yaml
receivers:
  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_KEY'
```

---

## 🎯 Best Practices

### 1. Set Appropriate Scrape Intervals

```yaml
# High-traffic apps: 15-30s
interval: 30s

# Low-traffic apps: 1-2m
interval: 1m
```

### 2. Use Labels Wisely

```yaml
# Good
sum(rate(http_server_requests_seconds_count[5m])) by (method, uri)

# Too granular (creates too many time series)
sum(rate(http_server_requests_seconds_count[5m])) by (method, uri, status, instance, pod)
```

### 3. Set Retention Based on Needs

```yaml
# Development: 7 days
retention: 7d

# Production: 30-90 days
retention: 30d
```

### 4. Use Recording Rules for Heavy Queries

```yaml
groups:
  - name: example
    interval: 30s
    rules:
      - record: job:http_requests:rate5m
        expr: sum(rate(http_server_requests_seconds_count[5m])) by (job)
```

---

## 🔍 Troubleshooting

### Prometheus Not Scraping App

**Check ServiceMonitor:**
```bash
kubectl get servicemonitor -A
kubectl describe servicemonitor devops-springboot-app-monitor
```

**Check Prometheus targets:**
```bash
# Port forward and check http://localhost:9090/targets
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
```

**Check app metrics endpoint:**
```bash
kubectl port-forward service/devops-springboot-app-service 8082:80
curl http://localhost:8082/actuator/prometheus
```

### Grafana Shows No Data

1. **Check datasource:** Settings → Data Sources → Prometheus → Test
2. **Check time range:** Adjust time picker in top-right
3. **Check query:** Use Prometheus UI to verify query works

### Alerts Not Firing

1. **Check PrometheusRule:**
   ```bash
   kubectl get prometheusrule -A
   kubectl describe prometheusrule devops-springboot-app-alerts
   ```

2. **Check alert state in Prometheus:**
   - http://localhost:9090/alerts

3. **Check Alertmanager:**
   ```bash
   kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-alertmanager 9093:9093
   # Open http://localhost:9093
   ```

---

## 📊 Monitoring Checklist

- [ ] Prometheus installed
- [ ] Grafana accessible
- [ ] Application exposing `/actuator/prometheus`
- [ ] ServiceMonitor created
- [ ] Can see metrics in Prometheus
- [ ] Dashboards showing data in Grafana
- [ ] Alerts configured
- [ ] Test alerts firing correctly
- [ ] Notifications configured (optional)

---

## 💰 Resource Usage

### Memory Requirements

**Prometheus:**
- Small setup: 512Mi - 2Gi
- Medium: 2Gi - 8Gi
- Large: 8Gi - 32Gi

**Grafana:**
- 128Mi - 512Mi (usually sufficient)

**Rule of thumb:** ~1-2 KB per time series

### Storage Requirements

**Prometheus:**
- ~1-2 bytes per sample
- Default scrape: every 30s
- Calculate: `time_series_count * (86400 / scrape_interval) * 2 bytes * retention_days`

Example:
- 1000 time series
- 30s scrape interval
- 7 days retention
- Storage: ~400 MB

---

## 🔗 Useful Links

- **Prometheus Docs**: https://prometheus.io/docs/
- **Grafana Docs**: https://grafana.com/docs/
- **Grafana Dashboards**: https://grafana.com/grafana/dashboards/
- **PromQL Tutorial**: https://prometheus.io/docs/prometheus/latest/querying/basics/
- **Micrometer Docs**: https://micrometer.io/docs/

---

## 🎓 What You've Learned

✅ **Observability**: Understanding system behavior through metrics  
✅ **Time-series Data**: How metrics are stored and queried  
✅ **PromQL**: Prometheus query language  
✅ **Alerting**: Proactive problem detection  
✅ **Dashboards**: Visual monitoring  
✅ **SLIs/SLOs**: Service level indicators and objectives  

---

**Status:** ✅ Monitoring stack configured and ready to deploy!

**Next:** Test the monitoring stack and create final project summary!
