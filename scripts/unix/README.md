# 🐧 Unix/Linux/macOS Script'leri

Sign API için Unix benzeri sistemler (Linux, macOS, BSD) için Bash script'leri.

## 📋 İçerik

| Script | Açıklama |
|--------|----------|
| `quick-start-with-test-certs.sh` | İnteraktif sertifika seçimi ve otomatik başlatma |
| `start-test1.sh` | Test Sertifikası 1 ile direkt başlatma |
| `start-test2.sh` | Test Sertifikası 2 ile direkt başlatma |
| `start-test3.sh` | Test Sertifikası 3 ile direkt başlatma |
| `test-with-bundled-certs.sh` | Tüm API endpoint'lerini otomatik test eder |

## 🚀 Kullanım

### İlk Kullanım

```bash
# Script'lere çalıştırma izni ver
chmod +x scripts/unix/*.sh

# İnteraktif başlatma
./scripts/unix/quick-start-with-test-certs.sh
```

### Direkt Başlatma

```bash
# Test Sertifikası 1
./scripts/unix/start-test1.sh

# Test Sertifikası 2
./scripts/unix/start-test2.sh

# Test Sertifikası 3
./scripts/unix/start-test3.sh
```

### Otomatik Test

```bash
# API'yi başlattıktan sonra
./scripts/unix/test-with-bundled-certs.sh
```

## 🔧 Gereksinimler

- Bash 4.0+
- curl
- Maven
- Java 8+

## 📖 Test Sertifikaları

| Sertifika | Parola |
|-----------|--------|
| `testkurum01@test.com.tr_614573.pfx` | `614573` |
| `testkurum02@sm.gov.tr_059025.pfx` | `059025` |
| `testkurum3@test.com.tr_181193.pfx` | `181193` |

## 💡 İpuçları

### Farklı Shell'lerde Çalıştırma

```bash
# Bash
bash ./scripts/unix/start-test1.sh

# Zsh (macOS varsayılan)
zsh ./scripts/unix/start-test1.sh

# sh (POSIX uyumlu)
sh ./scripts/unix/start-test1.sh
```

### Arka Planda Çalıştırma

```bash
# Arka planda başlat
./scripts/unix/start-test1.sh > /dev/null 2>&1 &

# Process ID'yi kaydet
APP_PID=$!

# Durdur
kill $APP_PID
```

### Çoklu Sertifika Test

```bash
for i in 1 2 3; do
  echo "Test Sertifikası $i ile başlatılıyor..."
  ./scripts/unix/start-test${i}.sh &
  sleep 20
  ./scripts/unix/test-with-bundled-certs.sh
  pkill -f spring-boot
  sleep 5
done
```

## 📚 İlgili Dökümanlar

- [Windows Script'leri](../windows/README.md)
- [Script'ler Ana Sayfa](../README.md)
- [TEST_CERTIFICATES.md](../../TEST_CERTIFICATES.md)

---

**Platform:** Unix/Linux/macOS  
**Shell:** Bash

