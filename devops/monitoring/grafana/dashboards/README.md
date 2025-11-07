# Grafana Dashboards

Bu klasöre Grafana dashboard JSON dosyalarını yerleştirebilirsiniz.

## 🎯 Önerilen Dashboard

**Dashboard ID: 11378** - Spring Boot 2.x Statistics

Bu dashboard'u Grafana UI üzerinden import edebilirsiniz:

1. Grafana'ya giriş yapın: http://localhost:3000
2. Sol menü → `+` → `Import`
3. Dashboard ID girin: `11378`
4. `Load` tıklayın
5. Prometheus data source seçin: `Prometheus`
6. `Import` tıklayın

## 📥 Dashboard URL

https://grafana.com/grafana/dashboards/11378

## 📁 Manuel Import

Dashboard JSON dosyasını indirip buraya yerleştirebilirsiniz:

```bash
# Dashboard indir
curl -L https://grafana.com/api/dashboards/11378/revisions/latest/download \
  -o monitoring/grafana/dashboards/spring-boot-statistics.json

# Docker Compose restart
docker-compose restart grafana
```

## 🔄 Otomatik Provisioning

`provisioning/dashboards/dashboard.yml` dosyası bu klasördeki tüm JSON dosyalarını otomatik olarak yükler.

---

**Not:** Dashboard'lar otomatik olarak yüklenecektir. Manual import'a gerek yoktur.

