# 🔍 Spring Boot Actuator Endpoints

Sign API, izleme ve sağlık kontrolü için Spring Boot Actuator endpoint'leri içerir.

## 📊 Mevcut Endpoint'ler

### 1. Health Check

API'nin sağlığını kontrol eder.

**URL:** `http://localhost:8085/actuator/health`

**Örnek Yanıt:**
```json
{
  "status": "UP"
}
```

**Kullanım:**
```bash
# Basit kontrol
curl http://localhost:8085/actuator/health

# jq ile formatlanmış
curl -s http://localhost:8085/actuator/health | jq

# Script içinde
if curl -s http://localhost:8085/actuator/health | grep -q '"status":"UP"'; then
  echo "API çalışıyor"
fi
```

### 2. Application Info

Uygulama hakkında bilgi verir.

**URL:** `http://localhost:8085/actuator/info`

**Örnek Yanıt:**
```json
{
  "app": {
    "name": "Mersel DSS Signer API",
    "description": "Dijital Imza Servisi API",
    "version": "0.1.0"
  }
}
```

**Kullanım:**
```bash
curl http://localhost:8085/actuator/info
```

### 3. Prometheus Metrics

Prometheus formatında tüm metrikleri export eder.

**URL:** `http://localhost:8085/actuator/prometheus`

**Örnek Yanıt:**
```
# HELP jvm_memory_used_bytes The amount of used memory
# TYPE jvm_memory_used_bytes gauge
jvm_memory_used_bytes{area="heap",id="PS Eden Space",} 4.567808E7

# HELP http_server_requests_seconds  
# TYPE http_server_requests_seconds summary
http_server_requests_seconds_count{method="POST",uri="/v1/xadessign",status="200",} 42.0
http_server_requests_seconds_sum{method="POST",uri="/v1/xadessign",status="200",} 12.456
```

**Kullanım:**
```bash
# Tüm metrics
curl http://localhost:8085/actuator/prometheus

# Belirli metric filtrele
curl -s http://localhost:8085/actuator/prometheus | grep "http_server_requests"

# Prometheus scrape test
curl -s http://localhost:8085/actuator/prometheus | head -50
```

> 📊 **Detaylı monitoring için:** [MONITORING.md](MONITORING.md)

### 4. Metrics Detail

Belirli bir metrik hakkında detaylı bilgi.

**URL:** `http://localhost:8085/actuator/metrics/{metricName}`

**Örnek:**
```bash
# HTTP requests metriği
curl http://localhost:8085/actuator/metrics/http.server.requests

# JVM memory metriği
curl http://localhost:8085/actuator/metrics/jvm.memory.used
```

## 🔧 Yapılandırma

`application.properties` dosyasında:

```properties
# Actuator Configuration
management.endpoints.web.exposure.include=health,info,prometheus,metrics
management.health.defaults.enabled=true
management.info.env.enabled=true

# Prometheus Metrics Configuration
management.metrics.export.prometheus.enabled=true
management.metrics.distribution.percentiles-histogram.http.server.requests=true
management.metrics.tags.application=${spring.application.name}
```

## 🛡️ Güvenlik

### Production Ortamı

Production'da Actuator endpoint'lerini korumanız önerilir:

```properties
# Sadece belirli endpoint'leri expose et
management.endpoints.web.exposure.include=health,info,prometheus

# Base path değiştir (optional)
management.endpoints.web.base-path=/monitoring

# Prometheus metrics için authentication (Spring Security ile)
# management.endpoint.prometheus.enabled=true
```

> 📊 **Tam monitoring kurulumu için:** [MONITORING.md](MONITORING.md)

## 📈 Prometheus ve Grafana

### Hızlı Başlangıç

1. **Prometheus scrape ekle** (`prometheus.yml`):
```yaml
scrape_configs:
  - job_name: 'sign-api'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['localhost:8085']
```

2. **Grafana Dashboard import et:**
   - Dashboard ID: **11378** (Spring Boot 2.x)
   - URL: https://grafana.com/grafana/dashboards/11378

> 📊 **Detaylı monitoring rehberi:** [MONITORING.md](MONITORING.md)

## 📊 Kubernetes/Docker ile Kullanım

### Liveness Probe

```yaml
livenessProbe:
  httpGet:
    path: /actuator/health
    port: 8085
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
```

### Readiness Probe

```yaml
readinessProbe:
  httpGet:
    path: /actuator/health
    port: 8085
  initialDelaySeconds: 20
  periodSeconds: 5
  timeoutSeconds: 3
  failureThreshold: 3
```

## 🔍 Monitoring

> **📊 Kapsamlı monitoring kurulumu için:** [MONITORING.md](MONITORING.md)

### Önerilen Grafana Dashboard

- **Dashboard ID: 11378** - Spring Boot 2.x (Önerilen)
- **Dashboard ID: 12900** - Spring Boot Micrometer (Detaylı)
- **Dashboard ID: 4701** - JVM Metrics

**Import:**
1. Grafana → `+` → `Import`
2. ID girin: `11378`
3. Prometheus data source seçin
4. Import

**Dashboard URL:** https://grafana.com/grafana/dashboards/11378

## 🧪 Test Script'lerinde Kullanım

### Başlangıç Kontrolü

```bash
#!/bin/bash

echo "API başlatılıyor..."
./scripts/start-test1.sh &
APP_PID=$!

# API'nin başlamasını bekle
for i in {1..30}; do
  if curl -s http://localhost:8085/actuator/health | grep -q "UP"; then
    echo "✅ API hazır!"
    break
  fi
  echo "Bekleniyor... ($i/30)"
  sleep 1
done

# Testleri çalıştır
./scripts/test-with-bundled-certs.sh

# Temizlik
kill $APP_PID
```

### CI/CD Pipeline

```yaml
# .github/workflows/test.yml
- name: Wait for API
  run: |
    for i in {1..30}; do
      if curl -s http://localhost:8085/actuator/health | grep -q "UP"; then
        echo "API is ready"
        exit 0
      fi
      sleep 1
    done
    echo "API failed to start"
    exit 1

- name: Run tests
  run: ./scripts/test-with-bundled-certs.sh
```

## 📚 İlgili Dökümanlar

- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [TEST_CERTIFICATES.md](../TEST_CERTIFICATES.md) - Test sertifikaları
- [README.md](../README.md) - Ana dokümantasyon
- [PERFORMANCE.md](PERFORMANCE.md) - Performance monitoring

## 💡 İpuçları

1. **Hızlı Health Check:** `curl -f http://localhost:8085/actuator/health || echo "API DOWN"`

2. **Watch mode:** `watch -n 2 'curl -s http://localhost:8085/actuator/health | jq'`

3. **Log ile birlikte:** 
   ```bash
   curl http://localhost:8085/actuator/health && tail -10 logs/application.log
   ```

4. **Script'te kullanım:**
   ```bash
   if ! curl -sf http://localhost:8085/actuator/health > /dev/null; then
     echo "⚠️  API yanıt vermiyor!"
     exit 1
   fi
   ```

---

**Not:** Actuator endpoint'leri production'da mutlaka güvenli hale getirilmelidir!

