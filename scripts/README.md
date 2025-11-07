# 🛠️ Scripts Klasörü

Bu klasörde Sign API için yardımcı script'ler bulunmaktadır.

## 📁 İçerik

### 🔐 Test Sertifikaları ile Başlatma

| Script | Açıklama |
|--------|----------|
| `quick-start-with-test-certs.sh` | İnteraktif sertifika seçimi ve otomatik başlatma |
| `start-test1.sh` | Test Sertifikası 1 ile direkt başlatma |
| `start-test2.sh` | Test Sertifikası 2 ile direkt başlatma |
| `start-test3.sh` | Test Sertifikası 3 ile direkt başlatma |

### 🧪 Test Scripts

| Script | Açıklama |
|--------|----------|
| `test-with-bundled-certs.sh` | Tüm API endpoint'lerini otomatik test eder |

### 🚀 Diğer

| Script | Açıklama |
|--------|----------|
| `prepare-github-release.sh` | GitHub release hazırlama |

## 🚀 Hızlı Kullanım

### İnteraktif Başlatma (Önerilen)

En basit yol - size sertifika seçtirip otomatik başlatır:

```bash
./scripts/quick-start-with-test-certs.sh
```

### Direkt Başlatma

Belirli bir sertifika ile direkt başlatmak için:

```bash
# Sertifika 1
./scripts/start-test1.sh

# Sertifika 2
./scripts/start-test2.sh

# Sertifika 3
./scripts/start-test3.sh
```

### API Testleri

API'yi başlattıktan sonra tüm endpoint'leri test etmek için:

```bash
./scripts/test-with-bundled-certs.sh
```

## 📖 Test Sertifikaları

Repo içinde kullanıma hazır 3 test sertifikası bulunmaktadır:

| Sertifika | Parola | Konum |
|-----------|--------|-------|
| `testkurum01@test.com.tr_614573.pfx` | `614573` | `resources/test-certs/` |
| `testkurum02@sm.gov.tr_059025.pfx` | `059025` | `resources/test-certs/` |
| `testkurum3@test.com.tr_181193.pfx` | `181193` | `resources/test-certs/` |

> 💡 **İpucu:** Dosya adında `_` karakterinden sonraki kısım paroladır.

## 🔄 Script Çalışma Mantığı

Tüm test sertifika script'leri:
1. Otomatik olarak proje root dizinine `cd` yapar
2. Gerekli environment variables'ları ayarlar
3. Maven ile uygulamayı başlatır

Bu sayede script'leri nereden çağırırsanız çağırın doğru çalışırlar:

```bash
# Root dizinden
./scripts/start-test1.sh

# Scripts dizininden
cd scripts && ./start-test1.sh

# Başka bir dizinden
/full/path/to/scripts/start-test1.sh
```

## 📚 Detaylı Dökümanlar

- **[TEST_CERTIFICATES.md](../TEST_CERTIFICATES.md)** - Kapsamlı test sertifikaları rehberi
- **[TEST_CERTS_CHEATSHEET.md](../TEST_CERTS_CHEATSHEET.md)** - Hızlı başvuru kılavuzu
- **[QUICK_START.md](../QUICK_START.md)** - Genel hızlı başlangıç
- **[README.md](../README.md)** - Ana dokümantasyon

## 💡 İpuçları

### Farklı Port ile Başlatma

```bash
export SERVER_PORT=9090
./scripts/start-test1.sh
```

### Debug Mode

```bash
export LOGGING_LEVEL_ROOT=DEBUG
./scripts/start-test1.sh
```

### TÜBİTAK Timestamp ile

```bash
# İnteraktif script içinde seçebilirsiniz
./scripts/quick-start-with-test-certs.sh

# Veya manuel
export IS_TUBITAK_TSP=true
export TS_USER_ID=your-id
export TS_USER_PASSWORD=your-password
./scripts/start-test1.sh
```

## 🛠️ Yeni Script Ekleme

Bu klasöre yeni script eklerken:

1. Script'i çalıştırılabilir yapın: `chmod +x script-name.sh`
2. Proje root'una cd yapmayı unutmayın: `cd "$(dirname "$0")/.."`
3. Bu README'yi güncelleyin
4. İlgili dökümanları güncelleyin

Örnek script başlangıcı:

```bash
#!/bin/bash
# Script açıklaması

set -e

# Proje root dizinine git
cd "$(dirname "$0")/.." || exit 1

# Script kodunuz...
```

## 🔧 Sorun Giderme

### "Permission denied"

```bash
chmod +x scripts/*.sh
```

### "No such file or directory"

Script'leri proje root dizininden çalıştırın veya tam yol kullanın.

### "PFX dosyası bulunamadı"

Test sertifikalarının `resources/` veya `src/main/resources/certs/` klasörlerinde olduğundan emin olun.

---

**Daha fazla yardım için:** [TEST_CERTIFICATES.md](../TEST_CERTIFICATES.md)

