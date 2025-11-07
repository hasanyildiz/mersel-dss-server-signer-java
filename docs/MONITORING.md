# 📊 Monitoring ve Metrics

Sign API, Prometheus ve Grafana ile kapsamlı monitoring desteği sunar.

## 🎯 Hızlı Başlangıç

### Prometheus Metrics Endpoint

API başlatıldıktan sonra metrics endpoint'i otomatik olarak aktiftir:

**URL:** `http://localhost:8085/actuator/prometheus`

```bash
# Metrics'i görüntüle
curl http://localhost:8085/actuator/prometheus

# jq ile filtrele
curl -s http://localhost:8085/actuator/metrics | jq
```

## 📈 Grafana Dashboard

### Önerilen Dashboard

**Grafana Dashboard ID:** `11378` (Spring Boot 2.x Dashboard)

**Import Adımları:**

1. Grafana'ya giriş yapın
2. `+` → `Import` tıklayın
3. Dashboard ID'yi girin: **11378**
4. `Load` tıklayın
5. Prometheus data source'u seçin
6. `Import` tıklayın

**Alternatif Dashboardlar:**
- **ID: 12900** - Spring Boot 2.x Micrometer (Detailed)
- **ID: 4701** - JVM (Micrometer)
- **ID: 10280** - Spring Boot Metrics

### Dashboard URL

https://grafana.com/grafana/dashboards/11378

## 🔧 Prometheus Yapılandırması

### Prometheus Configuration

`prometheus.yml` dosyanıza ekleyin:

```yaml
scrape_configs:
  - job_name: 'sign-api'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:8085']
        labels:
          application: 'mersel-dss-signer-api'
          environment: 'production'
```

### Docker Compose ile

```yaml
version: '3.8'

services:
  sign-api:
    image: mersel-dss-signer-api:latest
    ports:
      - "8085:8085"
    environment:
      - PFX_PATH=/certs/production.pfx
      - CERTIFICATE_PIN=${CERT_PIN}
      - CERTIFICATE_ALIAS=prod-cert

  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus

volumes:
  prometheus-data:
  grafana-data:
```

### Kubernetes ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    scrape_configs:
      - job_name: 'sign-api'
        kubernetes_sd_configs:
          - role: pod
            namespaces:
              names:
                - default
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_label_app]
            regex: sign-api
            action: keep
          - source_labels: [__meta_kubernetes_pod_ip]
            target_label: __address__
            replacement: '$1:8085'
          - source_labels: [__meta_kubernetes_pod_name]
            target_label: pod
```

## 📊 Önemli Metrikler

### Genel Uygulama Metrikleri

```promql
# CPU Kullanımı
process_cpu_usage

# Memory Kullanımı
jvm_memory_used_bytes{area="heap"}

# Garbage Collection
rate(jvm_gc_pause_seconds_sum[5m])

# Thread Sayısı
jvm_threads_live
```

### HTTP İstek Metrikleri

```promql
# Request Rate (QPS)
rate(http_server_requests_seconds_count{uri="/v1/xadessign"}[5m])

# Response Time (p50, p95, p99)
histogram_quantile(0.95, 
  sum(rate(http_server_requests_seconds_bucket[5m])) by (le, uri)
)

# Error Rate
rate(http_server_requests_seconds_count{status=~"5.."}[5m])

# Request Duration
http_server_requests_seconds_sum / http_server_requests_seconds_count
```

### İmzalama Performansı

```promql
# XAdES İmzalama Rate
rate(http_server_requests_seconds_count{uri="/v1/xadessign",status="200"}[5m])

# PAdES İmzalama Rate  
rate(http_server_requests_seconds_count{uri="/v1/padessign",status="200"}[5m])

# Ortalama İmzalama Süresi
rate(http_server_requests_seconds_sum{uri=~"/v1/.*sign"}[5m]) 
/ 
rate(http_server_requests_seconds_count{uri=~"/v1/.*sign"}[5m])
```

### JVM Metrikleri

```promql
# Heap Memory Kullanımı (%)
100 * (jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"})

# GC Pause Time
rate(jvm_gc_pause_seconds_sum[5m])

# Class Loading
jvm_classes_loaded_classes
```

## 🚨 Alert Rules

### Prometheus Alert Rules

```yaml
groups:
  - name: sign-api-alerts
    interval: 30s
    rules:
      # API Down
      - alert: SignApiDown
        expr: up{job="sign-api"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Sign API is down"
          description: "Sign API has been down for more than 1 minute"

      # High Error Rate
      - alert: HighErrorRate
        expr: |
          (
            rate(http_server_requests_seconds_count{status=~"5.."}[5m])
            /
            rate(http_server_requests_seconds_count[5m])
          ) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          description: "Error rate is above 5% for 5 minutes"

      # High Response Time
      - alert: HighResponseTime
        expr: |
          histogram_quantile(0.95,
            rate(http_server_requests_seconds_bucket[5m])
          ) > 5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High response time"
          description: "95th percentile response time is above 5 seconds"

      # High Memory Usage
      - alert: HighMemoryUsage
        expr: |
          100 * (
            jvm_memory_used_bytes{area="heap"}
            /
            jvm_memory_max_bytes{area="heap"}
          ) > 90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High heap memory usage"
          description: "Heap memory usage is above 90%"

      # High GC Time
      - alert: HighGCTime
        expr: rate(jvm_gc_pause_seconds_sum[5m]) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High GC pause time"
          description: "GC is consuming more than 50% of time"
```

## 📊 Grafana Dashboard Örnekleri

### Panel Örnekleri

#### Request Rate Panel

```json
{
  "targets": [
    {
      "expr": "rate(http_server_requests_seconds_count{job=\"sign-api\"}[5m])",
      "legendFormat": "{{uri}} - {{method}}",
      "refId": "A"
    }
  ],
  "title": "Request Rate (req/s)",
  "type": "graph"
}
```

#### Response Time Percentiles

```json
{
  "targets": [
    {
      "expr": "histogram_quantile(0.50, sum(rate(http_server_requests_seconds_bucket{job=\"sign-api\"}[5m])) by (le))",
      "legendFormat": "p50",
      "refId": "A"
    },
    {
      "expr": "histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket{job=\"sign-api\"}[5m])) by (le))",
      "legendFormat": "p95",
      "refId": "B"
    },
    {
      "expr": "histogram_quantile(0.99, sum(rate(http_server_requests_seconds_bucket{job=\"sign-api\"}[5m])) by (le))",
      "legendFormat": "p99",
      "refId": "C"
    }
  ],
  "title": "Response Time Percentiles",
  "type": "graph"
}
```

## 🔍 Kullanılabilir Metrikler

### HTTP Metrikleri

```bash
# Tüm HTTP metrikleri
curl -s http://localhost:8085/actuator/metrics | jq '.names[] | select(contains("http"))'

# Belirli bir metrik detayı
curl -s http://localhost:8085/actuator/metrics/http.server.requests | jq
```

**Örnek metrikler:**
- `http_server_requests_seconds_count` - Toplam istek sayısı
- `http_server_requests_seconds_sum` - Toplam istek süresi
- `http_server_requests_seconds_max` - Maksimum istek süresi

### JVM Metrikleri

- `jvm_memory_used_bytes` - Kullanılan memory
- `jvm_memory_max_bytes` - Maksimum memory
- `jvm_gc_pause_seconds_count` - GC pause sayısı
- `jvm_threads_live` - Aktif thread sayısı
- `jvm_classes_loaded_classes` - Yüklü class sayısı

### System Metrikleri

- `system_cpu_usage` - CPU kullanımı
- `system_load_average_1m` - Load average
- `process_uptime_seconds` - Uptime

## 🚀 Hızlı Test

### Prometheus Metrics Test

```bash
# API'yi başlat
./scripts/start-test1.sh &
APP_PID=$!
sleep 15

# Metrics endpoint'i kontrol et
curl -s http://localhost:8085/actuator/prometheus | head -20

# Belirli bir metrik
curl -s http://localhost:8085/actuator/prometheus | grep "http_server_requests"

# Temizlik
kill $APP_PID
```

### Grafana Dashboard Import

1. **Grafana'ya giriş yapın:** http://localhost:3000 (varsayılan: admin/admin)

2. **Dashboard Import:**
   - Sol menüden `+` → `Import`
   - Dashboard ID girin: **11378**
   - `Load` tıklayın
   - Prometheus data source seçin
   - `Import` tıklayın

3. **Verileri görüntüleyin:**
   - API'ye istek gönderin
   - Dashboard'da metrikleri izleyin

## 📦 Production Deployment

### Docker Compose Örneği

Tam monitoring stack:

```yaml
version: '3.8'

services:
  sign-api:
    image: mersel-dss-signer-api:0.1.0
    container_name: sign-api
    ports:
      - "8085:8085"
    environment:
      - PFX_PATH=/certs/production.pfx
      - CERTIFICATE_PIN=${CERT_PIN}
      - CERTIFICATE_ALIAS=prod-cert
      - IS_TUBITAK_TSP=true
      - TS_USER_ID=${TS_USER}
      - TS_USER_PASSWORD=${TS_PASS}
    volumes:
      - ./certs:/certs:ro
    networks:
      - monitoring
    restart: unless-stopped

  prometheus:
    image: prom/prometheus:v2.48.0
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./monitoring/alerts.yml:/etc/prometheus/alerts.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.enable-lifecycle'
    networks:
      - monitoring
    restart: unless-stopped

  grafana:
    image: grafana/grafana:10.2.0
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD:-admin}
      - GF_INSTALL_PLUGINS=grafana-piechart-panel
    volumes:
      - grafana-data:/var/lib/grafana
      - ./monitoring/grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./monitoring/grafana/datasources:/etc/grafana/provisioning/datasources
    networks:
      - monitoring
    depends_on:
      - prometheus
    restart: unless-stopped

  alertmanager:
    image: prom/alertmanager:v0.26.0
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./monitoring/alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - alertmanager-data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/alertmanager'
    networks:
      - monitoring
    restart: unless-stopped

networks:
  monitoring:
    driver: bridge

volumes:
  prometheus-data:
  grafana-data:
  alertmanager-data:
```

### Prometheus Config (`monitoring/prometheus.yml`)

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'production'
    region: 'tr-istanbul'

# Alerting configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093

# Alert rules
rule_files:
  - 'alerts.yml'

# Scrape configurations
scrape_configs:
  - job_name: 'sign-api'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 15s
    scrape_timeout: 10s
    static_configs:
      - targets: ['sign-api:8085']
        labels:
          application: 'sign-api'
          environment: 'production'
    
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

## 📊 Önemli Metrikler

### İmzalama Performansı

| Metric | Açıklama | Sorgu |
|--------|----------|-------|
| **İmza Rate** | Saniyede kaç imza | `rate(http_server_requests_seconds_count{uri="/v1/xadessign",status="200"}[5m])` |
| **Ortalama Süre** | Ortalama imzalama süresi | `rate(http_server_requests_seconds_sum{uri=~"/v1/.*sign"}[5m]) / rate(http_server_requests_seconds_count{uri=~"/v1/.*sign"}[5m])` |
| **Error Rate** | Hata oranı | `rate(http_server_requests_seconds_count{status=~"5.."}[5m]) / rate(http_server_requests_seconds_count[5m])` |
| **p95 Latency** | 95. yüzdelik yanıt süresi | `histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m]))` |

### Sistem Metrikleri

| Metric | Açıklama | Hedef |
|--------|----------|-------|
| **CPU Usage** | CPU kullanımı | < 70% |
| **Heap Memory** | Heap memory kullanımı | < 80% |
| **GC Time** | Garbage collection süresi | < 10% |
| **Thread Count** | Aktif thread sayısı | < 100 |

## 🎨 Custom Metrics

### Özel Metrik Ekleme

Sign API'ye özel metrikler eklemek için:

```java
@Service
public class CustomMetricsService {
    
    private final Counter signatureCounter;
    private final Timer signatureTimer;
    
    public CustomMetricsService(MeterRegistry registry) {
        this.signatureCounter = Counter.builder("signature.created")
            .description("Total signatures created")
            .tag("type", "xades")
            .register(registry);
            
        this.signatureTimer = Timer.builder("signature.duration")
            .description("Signature creation duration")
            .publishPercentiles(0.5, 0.95, 0.99)
            .register(registry);
    }
    
    public void recordSignature(String type, Runnable operation) {
        signatureTimer.record(() -> {
            operation.run();
            signatureCounter.increment();
        });
    }
}
```

## 🔔 Alerting

### AlertManager Configuration (`monitoring/alertmanager.yml`)

```yaml
global:
  resolve_timeout: 5m
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@example.com'
  smtp_auth_username: 'alerts@example.com'
  smtp_auth_password: 'your-password'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  receiver: 'team-email'

receivers:
  - name: 'team-email'
    email_configs:
      - to: 'team@example.com'
        headers:
          Subject: '🚨 Sign API Alert: {{ .GroupLabels.alertname }}'

  - name: 'slack-notifications'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
        channel: '#alerts'
        title: 'Sign API Alert'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

## 📈 Dashboard Paneller

### Önerilen Panel Düzeni

1. **Genel Bakış (Row 1)**
   - Uptime
   - Total Requests (24h)
   - Error Rate
   - Average Response Time

2. **İmzalama Metrikleri (Row 2)**
   - XAdES Signature Rate
   - PAdES Signature Rate
   - WS-Security Signature Rate
   - Signature Duration (p95)

3. **Sistem Kaynakları (Row 3)**
   - CPU Usage
   - Heap Memory Usage
   - GC Activity
   - Thread Count

4. **HTTP Metrikleri (Row 4)**
   - Request Rate by Endpoint
   - Response Time Heatmap
   - Status Code Distribution
   - Error Log Panel

## 🧪 Test ve Debugging

### Metrics Testi

```bash
# Belirli bir endpoint'e load gönder
for i in {1..100}; do
  curl -X POST http://localhost:8085/v1/xadessign \
    -F "document=@test.xml" \
    -F "documentType=None" \
    -o /dev/null -s &
done
wait

# Metrics'i kontrol et
curl -s http://localhost:8085/actuator/metrics/http.server.requests | jq '.measurements'
```

### Prometheus Query Testi

```bash
# Prometheus UI'da test et
# http://localhost:9090/graph

# veya API ile
curl 'http://localhost:9090/api/v1/query?query=up{job="sign-api"}'
```

## 📚 Grafana Dashboard JSON

Özel dashboard için temel template:

```json
{
  "dashboard": {
    "title": "Sign API Monitoring",
    "tags": ["sign-api", "digital-signature"],
    "timezone": "browser",
    "panels": [
      {
        "title": "API Uptime",
        "targets": [
          {
            "expr": "up{job=\"sign-api\"}",
            "legendFormat": "Status"
          }
        ],
        "type": "stat"
      },
      {
        "title": "Request Rate",
        "targets": [
          {
            "expr": "rate(http_server_requests_seconds_count{job=\"sign-api\"}[5m])",
            "legendFormat": "{{uri}}"
          }
        ],
        "type": "graph"
      }
    ]
  }
}
```

## 🔧 Yapılandırma Özeti

### application.properties

```properties
# Actuator & Prometheus
management.endpoints.web.exposure.include=health,info,prometheus,metrics
management.metrics.export.prometheus.enabled=true
management.metrics.distribution.percentiles-histogram.http.server.requests=true
management.metrics.tags.application=${spring.application.name}
```

### Dependency (pom.xml)

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

## 💡 Best Practices

### 1. Metric Retention

```yaml
# Prometheus retention (90 gün)
--storage.tsdb.retention.time=90d
--storage.tsdb.retention.size=50GB
```

### 2. Dashboard Backup

```bash
# Grafana dashboard'ları export et
curl -H "Authorization: Bearer ${GRAFANA_API_KEY}" \
  http://localhost:3000/api/dashboards/db/sign-api-monitoring \
  | jq '.dashboard' > sign-api-dashboard.json
```

### 3. Alert Testing

```bash
# Alert'leri test et
curl -X POST http://localhost:9093/api/v1/alerts \
  -H "Content-Type: application/json" \
  -d '[{
    "labels": {"alertname": "TestAlert", "severity": "warning"},
    "annotations": {"summary": "Test alert"}
  }]'
```

## 📚 İlgili Dökümanlar

- [ACTUATOR_ENDPOINTS.md](ACTUATOR_ENDPOINTS.md) - Actuator endpoint'leri
- [PERFORMANCE.md](PERFORMANCE.md) - Performance optimization
- [README.md](../README.md) - Ana dokümantasyon

## 🔗 Faydalı Linkler

- [Grafana Dashboard 11378](https://grafana.com/grafana/dashboards/11378) - Spring Boot 2.x
- [Grafana Dashboard 12900](https://grafana.com/grafana/dashboards/12900) - Spring Boot Micrometer
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Micrometer Documentation](https://micrometer.io/docs)

---

**🎯 Önerilen Grafana Dashboard ID: 11378** - Spring Boot 2.x için optimize edilmiş, hazır kullanım!

