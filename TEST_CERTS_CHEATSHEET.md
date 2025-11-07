# 🚀 Test Sertifikaları Hızlı Başvuru (Cheatsheet)

## ⚠️ ÖNEMLİ UYARI

**Bu test sertifikaları SADECE geliştirme/test içindir!**  
**Production'da ASLA kullanmayın!** Production için resmi CA sertifikası kullanın.

## 📋 Hızlı Komutlar

### Tek Komutla Başlat (İnteraktif)

```bash
./scripts/quick-start-with-test-certs.sh
```

### Direkt Başlatma (Sertifika Seçerek)

```bash
# Test Sertifikası 1
./scripts/start-test1.sh

# Test Sertifikası 2
./scripts/start-test2.sh

# Test Sertifikası 3
./scripts/start-test3.sh
```

### Manuel Başlatma

```bash
# Sertifika 1
export PFX_PATH=./resources/test-certs/testkurum01@test.com.tr_614573.pfx
export CERTIFICATE_PIN=614573
export CERTIFICATE_ALIAS=1
export IS_TUBITAK_TSP=false
mvn spring-boot:run

# Sertifika 2
export PFX_PATH=./resources/test-certs/testkurum02@sm.gov.tr_059025.pfx
export CERTIFICATE_PIN=059025
export CERTIFICATE_ALIAS=1
export IS_TUBITAK_TSP=false
mvn spring-boot:run

# Sertifika 3
export PFX_PATH=./resources/test-certs/testkurum3@test.com.tr_181193.pfx
export CERTIFICATE_PIN=181193
export CERTIFICATE_ALIAS=1
export IS_TUBITAK_TSP=false
mvn spring-boot:run
```

## 🧪 Test Komutları

### Otomatik Test

```bash
./scripts/test-with-bundled-certs.sh
```

### Manuel Test - XML İmzalama

```bash
echo '<?xml version="1.0"?><test>data</test>' > test.xml
curl -X POST http://localhost:8085/v1/xadessign \
  -F "document=@test.xml" \
  -F "documentType=None" \
  -o signed.xml
```

### Manuel Test - PDF İmzalama

```bash
curl -X POST http://localhost:8085/v1/padessign \
  -F "document=@document.pdf" \
  -F "appendMode=false" \
  -o signed.pdf
```

### Manuel Test - SOAP İmzalama

```bash
curl -X POST http://localhost:8085/v1/wssecuritysign \
  -F "document=@soap.xml" \
  -F "soap1Dot2=false" \
  -o signed-soap.xml
```

## 📊 Sertifika Bilgileri

| Özellik | Sertifika 1 | Sertifika 2 | Sertifika 3 |
|---------|------------|------------|------------|
| **Dosya** | `testkurum01@test.com.tr_614573.pfx` | `testkurum02@sm.gov.tr_059025.pfx` | `testkurum3@test.com.tr_181193.pfx` |
| **Parola** | `614573` | `059025` | `181193` |
| **Email** | testkurum01@test.com.tr | testkurum02@sm.gov.tr | testkurum3@test.com.tr |
| **Konum** | `resources/test-certs/` | `resources/test-certs/` | `resources/test-certs/` |

## 🔍 Sertifika İnceleme

```bash
# Sertifika 1
keytool -list -v -keystore resources/test-certs/testkurum01@test.com.tr_614573.pfx \
  -storetype PKCS12 -storepass 614573

# Sertifika 2
keytool -list -v -keystore resources/test-certs/testkurum02@sm.gov.tr_059025.pfx \
  -storetype PKCS12 -storepass 059025

# Sertifika 3
keytool -list -v -keystore resources/test-certs/testkurum3@test.com.tr_181193.pfx \
  -storetype PKCS12 -storepass 181193
```

## 🌐 API Endpoint'leri

| Endpoint | Açıklama |
|----------|----------|
| `http://localhost:8085` | API Base URL |
| `http://localhost:8085/swagger/index.html` | Swagger UI (API Dokümantasyonu) |
| `http://localhost:8085/actuator/health` | Health Check (Sağlık Kontrolü) |
| `http://localhost:8085/actuator/info` | Application Info (Uygulama Bilgisi) |
| `http://localhost:8085/actuator/prometheus` | Prometheus Metrics (Monitoring) |
| `http://localhost:8085/actuator/metrics` | Metrics Detail (JSON) |
| `http://localhost:8085/v1/xadessign` | XAdES İmzalama |
| `http://localhost:8085/v1/padessign` | PAdES (PDF) İmzalama |
| `http://localhost:8085/v1/wssecuritysign` | WS-Security İmzalama |
| `http://localhost:8085/api/tubitak/credit` | TÜBİTAK Kontör |

## 🛠️ Faydalı Komutlar

### API Durumu Kontrolü

```bash
# API sağlık kontrolü
curl -s http://localhost:8085/actuator/health

# Uygulama bilgileri
curl -s http://localhost:8085/actuator/info

# Prometheus metrics
curl -s http://localhost:8085/actuator/prometheus | head -20

# Belirli metrik detayı
curl -s http://localhost:8085/actuator/metrics/http.server.requests | jq

# Port dinleniyor mu?
lsof -i :8085

# Process ID bul
ps aux | grep java | grep spring-boot
```

### Log Kontrolü

```bash
# Canlı log izle
tail -f logs/application.log

# Hata logları
tail -f logs/error.log

# İmzalama logları
tail -f logs/signature.log

# Son 100 satır
tail -n 100 logs/application.log
```

### Cleanup (Temizlik)

```bash
# Maven temizle
mvn clean

# Log'ları temizle
rm -f logs/*.log

# Test dosyalarını temizle
rm -f test*.xml signed*.xml signed*.pdf
```

## 🔄 Sertifika Değiştirme (Çalışırken)

```bash
# 1. API'yi durdur (Ctrl+C veya)
pkill -f "spring-boot:run"

# 2. Yeni sertifika ayarla
export PFX_PATH=./resources/test-certs/testkurum02@sm.gov.tr_059025.pfx
export CERTIFICATE_PIN=059025
export CERTIFICATE_ALIAS=1

# 3. Yeniden başlat
mvn spring-boot:run
```

## 📦 Toplu İşlemler

### Tüm Testleri Çalıştır

```bash
# API'yi başlat
./scripts/start-test1.sh &
API_PID=$!

# API'nin başlamasını bekle
sleep 15

# Testleri çalıştır
./scripts/test-with-bundled-certs.sh

# API'yi durdur
kill $API_PID
```

### Tüm Sertifikalarla Test

```bash
for i in 1 2 3; do
  echo "🔐 Test Sertifikası $i ile test başlıyor..."
  ./scripts/start-test${i}.sh &
  APP_PID=$!
  sleep 15
  
  curl -s -X POST http://localhost:8085/v1/xadessign \
    -F "document=@test.xml" \
    -F "documentType=None" \
    -o "signed-cert${i}.xml"
  
  kill $APP_PID
  wait $APP_PID 2>/dev/null
  sleep 2
done
```

## 🐛 Sorun Giderme

### "Connection refused"

```bash
# API'nin çalıştığını doğrula
curl http://localhost:8085/swagger/index.html

# Port'un dinlendiğini doğrula
lsof -i :8085
```

### "Keystore yüklenemedi"

```bash
# Dosyanın varlığını kontrol et
ls -la $PFX_PATH

# Dosya tipini kontrol et
file $PFX_PATH

# Parolayı kontrol et
echo $CERTIFICATE_PIN
```

### "Maven bulunamadı"

```bash
# Maven versiyonunu kontrol et
mvn -version

# Maven'i yükle (macOS)
brew install maven

# Maven'i yükle (Ubuntu/Debian)
sudo apt-get install maven
```

### "Java versiyonu uyumsuz"

```bash
# Java versiyonunu kontrol et
java -version

# Java'yı güncelle (macOS)
brew install openjdk@11

# JAVA_HOME ayarla
export JAVA_HOME=/path/to/java
```

## 📚 Detaylı Dökümanlar

- [TEST_CERTIFICATES.md](TEST_CERTIFICATES.md) - Tam test sertifikaları rehberi
- [QUICK_START.md](QUICK_START.md) - Genel hızlı başlangıç
- [README.md](README.md) - Ana dokümantasyon
- [examples/README.md](examples/README.md) - Kullanım örnekleri

## 💡 Yararlı İpuçları

1. **Farklı portlarda çalıştır:**
   ```bash
   export SERVER_PORT=9090
   ./start-test1.sh
   ```

2. **Debug mode:**
   ```bash
   export LOGGING_LEVEL_ROOT=DEBUG
   ./start-test1.sh
   ```

3. **Timestamp etkinleştir:**
   ```bash
   export IS_TUBITAK_TSP=true
   export TS_USER_ID=your-id
   export TS_USER_PASSWORD=your-password
   ./scripts/start-test1.sh
   ```

4. **Hızlı yeniden başlatma:**
   ```bash
   pkill -f spring-boot; sleep 2; ./scripts/start-test1.sh
   ```

---

**Not:** Bu döküman test sertifikaları için hazırlanmıştır. Production ortamı için [README.md](README.md) dosyasına bakın.

