# Changelog

Tüm önemli değişiklikler bu dosyada dokümante edilmektedir.

Format [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) standardına dayanmaktadır,
ve bu proje [Semantic Versioning](https://semver.org/spec/v2.0.0.html) kullanmaktadır.

## [Unreleased]

### Added


- 🖥️ **Cross-Platform Script Desteği** - Windows ve Unix için ayrı script'ler
  - **Unix/Linux/macOS** (`scripts/unix/`)
    - 5 bash script (.sh)
    - Tam özellik desteği
    - Renkli terminal çıktısı
  - **Windows PowerShell** (`scripts/windows/`)
    - 4 PowerShell script (.ps1)
    - Modern Windows (10/11) için optimize
    - Renkli çıktı desteği
    - Execution policy yönetimi
  - Her platform için ayrı README dökümanları

- 🚀 **Hızlı Başlatma Script'leri** - Hazır test sertifikaları ile tek komutla başlatma
  - **İnteraktif Script**: `scripts/quick-start-with-test-certs.sh` - Sertifika seçimi ve otomatik yapılandırma
  - **Direkt Başlatma**: `scripts/start-test1.sh`, `start-test2.sh`, `start-test3.sh` - Her sertifika için ayrı script
  - **Otomatik Test**: `scripts/test-with-bundled-certs.sh` - Tüm API endpoint'lerini otomatik test eder
  - Renkli terminal çıktısı ve kullanıcı dostu mesajlar
  - TÜBİTAK timestamp opsiyonel yapılandırma desteği
  - Environment variable'lar otomatik ayarlanır
  - Cross-directory çalışma desteği (nereden çağırılırsa çağırılsın çalışır)

- 📊 **Prometheus Metrics Export** - Production-grade monitoring desteği
  - **Micrometer Prometheus Registry** dependency eklendi
  - **Prometheus Endpoint**: `/actuator/prometheus` - 40+ metrik export edilir
  - **Metrics Detail Endpoint**: `/actuator/metrics/{name}` - Belirli metrik detayları
  - HTTP request metrics (count, duration, percentiles)
  - JVM metrics (memory, GC, threads, classes)
  - System metrics (CPU, disk, uptime)
  - Tomcat metrics (sessions, threads)
  - Percentile histogram desteği (p50, p95, p99)
  - Application tagging (multi-instance monitoring için)

- 🔍 **Spring Boot Actuator** - Health check ve monitoring
  - **Health Check Endpoint**: `/actuator/health` - API sağlık durumu
  - **Info Endpoint**: `/actuator/info` - Uygulama bilgileri
  - Kubernetes liveness/readiness probe desteği
  - Docker health check desteği
  - CI/CD pipeline entegrasyonu için hazır

- 📚 **Kapsamlı Monitoring Dökümanları**
  - **docs/MONITORING.md** - Prometheus & Grafana kurulum rehberi
    - Önerilen Grafana Dashboard ID: **11378** (Spring Boot 2.x)
    - Docker Compose monitoring stack örneği
    - Prometheus scrape yapılandırması
    - Alert rules örnekleri (API down, high error rate, high memory, vb.)
    - Grafana panel örnekleri
    - Önemli metrikler ve PromQL sorguları
    - Production deployment örnekleri (Docker, Kubernetes)
  - **docs/ACTUATOR_ENDPOINTS.md** - Actuator endpoint'leri detaylı rehber
    - Health, Info, Prometheus, Metrics endpoint'leri
    - Kubernetes probe yapılandırması
    - CI/CD entegrasyon örnekleri
  - **TEST_CERTIFICATES.md** - Test sertifikaları kullanım rehberi
  - **TEST_CERTS_CHEATSHEET.md** - Hızlı başvuru kılavuzu
  - **scripts/README.md** - Script'ler dökümanı

- 🔐 **Test Sertifikaları** - Geliştirme ortamı için hazır sertifikalar
  - 3 adet test PFX sertifikası (`resources/test-certs/`)
  - `testkurum01@test.com.tr_614573.pfx` (Parola: 614573)
  - `testkurum02@sm.gov.tr_059025.pfx` (Parola: 059025)
  - `testkurum3@test.com.tr_181193.pfx` (Parola: 181193)
  - Dosya isminde `_` sonrası parola formatı (kullanıcı dostu)
  - Güvenilir kök sertifikalarla uyumlu (normal doğrulama çalışır)

- 🔥 **Sertifika Listeleme API'si** - Native Java ile keystore sertifikalarını listeleme
  - **REST API**: `GET /api/certificates/list` - Çalışan API'den sertifika listesi
  - **REST API**: `GET /api/certificates/info` - Keystore bilgileri
  - **Command-line Utility**: `java -jar xxx.jar --list-certificates` - API başlatmadan sertifikaları listele
  - **Cross-platform**: macOS ARM64, Linux, Windows'da sorunsuz çalışır
  - **Mimari bağımsız**: Java'nın native PKCS#11 desteği kullanılır
  - **JSON output**: REST API ile programatik erişim
  - **Pretty console output**: CLI ile renkli, formatlanmış çıktı
  - Hem PKCS#11 hem PFX desteği
  - Alias, serial number (hex/dec), subject, issuer, validity bilgileri
  - Private key kontrolü
  - **OID Bilgileri**: Key Usage, Extended Key Usage, Certificate Policies (ham değerler)
  - **Policy Qualifiers**: CPS URL'leri ve User Notice metinleri sertifikadan parse edilir
  - **No OID Mapping**: OID'ler olduğu gibi gösterilir, her TSP'ye özel mapping yok
  - Kullanıcılar OID'leri görebilir ve kendi araştırmalarını yapabilir
  
- 📘 **Sertifika Seçimi Dokümantasyonu** - Kapsamlı sertifika seçimi rehberi (docs/CERTIFICATE_SELECTION.md)
  - Alias ile sertifika seçimi detayları
  - Serial number ile sertifika seçimi (hexadecimal format)
  - Öncelik sırası açıklaması
  - Sertifika bilgilerini bulma yöntemleri (4 pratik yöntem)
  - **⚠️ Kritik bölüm**: Doğru sertifikayı seçme rehberi
  - **Mali Mühür**: SIGN0 vs ENCR0 ayrımı, Extended Key Usage kontrolü
  - **Bireysel E-İmza**: Key Usage (Digital Signature + Non Repudiation) kontrolü
  - Gerçek örneklerle pratik senaryolar
  - macOS ARM64 mimari sorunları ve çözümleri
  - Best practices ve karar tablosu
  
- 🔧 **find-certificate-info.sh** - PFX ve PKCS#11'den sertifika bilgilerini çıkaran helper script
  - Alias listesi görüntüleme
  - Serial number (hex) çıkarma
  - Environment variable örnekleri oluşturma
  - macOS ARM64 tespit ve Rosetta desteği
  - Java fallback mekanizması
  - Hem PFX hem PKCS#11 desteği

### Changed

- 🔧 **Sertifika Yapılandırması İyileştirmeleri**
  - `CERTIFICATE_SERIAL_NUMBER` artık opsiyonel (varsayılan: boş string)
  - `CERTIFICATE_ALIAS` artık opsiyonel (varsayılan: boş string)
  - SignatureServiceConfiguration - Varsayılan değerler eklendi
  - Test sertifikaları için `CERTIFICATE_ALIAS=1` kullanımı
  - Sertifika bulunamazsa daha açıklayıcı hata mesajları

- 📖 **Dokümantasyon İyileştirmeleri**
  - README.md - Monitoring bölümü ve Grafana Dashboard ID eklendi
  - README.md - Actuator endpoint'leri listeye eklendi
  - QUICK_START.md - Test sertifikaları bölümü eklendi (öncelikli pozisyon)
  - QUICK_START.md - Health check endpoint referansları
  - SECURITY.md - Test sertifikaları güvenlik uyarısı eklendi
  - examples/curl/README.md - Test script'leri referansları
  - application.properties - Actuator ve Prometheus yapılandırması eklendi

- 📁 **Script Organizasyonu**
  - Script'ler platform bazlı organize edildi
  - `scripts/unix/` - Unix/Linux/macOS bash script'leri
  - `scripts/windows/` - Windows PowerShell ve Batch script'leri
  - Her platform için ayrı README
  - Script'ler otomatik olarak proje root dizinine geçer
  - Yerden bağımsız çalışma desteği (portable scripts)
  
- 🎯 **SignatureApplication** - Command-line argüman desteği
  - `--list-certificates` / `--list-certs`: Sertifikaları listele
  - `--help` / `-h`: Yardım mesajı
  - `--version` / `-v`: Versiyon bilgisi
  - Spring context olmadan hızlı çalışma

### Improved

- 🧪 **Test Workflow İyileştirmeleri**
  - `test-with-bundled-certs.sh` - Actuator health check ile API hazır kontrolü
  - Daha güvenilir başlangıç kontrolü
  - Renkli test sonuçları ve özet rapor
  - Otomatik test dosyası oluşturma (XML, PDF, SOAP)

### Technical Details

- **pom.xml Güncellemeleri**
  - `spring-boot-starter-actuator` dependency eklendi
  - `micrometer-registry-prometheus` dependency eklendi
  - Spring Boot parent version: 2.7.18

- **application.properties Yapılandırması**
  - `management.endpoints.web.exposure.include=health,info,prometheus,metrics`
  - `management.metrics.export.prometheus.enabled=true`
  - `management.metrics.distribution.percentiles-histogram.http.server.requests=true`
  - `management.metrics.tags.application=${spring.application.name}`

- **Sertifika Validation**
  - CertificateValidatorService - Normal güven doğrulaması korundu
  - Test sertifikaları güvenilir köklerle çalışıyor
  - SKIP_CERTIFICATE_TRUST_VALIDATION gereksiz karmaşıklık kaldırıldı

- **Yeni DTO**: `CertificateInfoDto` - Sertifika bilgileri (alias, serial, OID'ler)
- **Yeni Service**: `CertificateInfoService` - Keystore okuma ve OID extraction
  - `extractKeyUsage()` - 9 farklı Key Usage biti
  - `extractExtendedKeyUsage()` - Extended Key Usage OID'leri
  - `extractCertificatePolicies()` - Policy OID'leri + CPS/User Notice qualifiers
- **Yeni Controller**: `CertificateInfoController` - REST endpoint'leri
- Mevcut kod zaten hem alias hem de serial number desteğine sahipti
- `KeyStoreLoaderService.resolveKeyEntry()` her iki yöntemi de destekliyor
- BigInteger ile hex formatı doğru şekilde parse ediliyor
- Öncelik sırası: 1) Alias → 2) Serial Number → 3) Otomatik seçim

### Design Philosophy
- ✅ **No OID mapping**: OID'ler sertifikadan okunan ham değerler olarak gösterilir
- ✅ **Show, don't interpret**: Her TSP'nin farklı OID yapısı var, mapping yerine ham veri
- ✅ **CPS reference**: Kullanıcılar sertifika içindeki CPS URL'den detaylı bilgi alabilir
- ✅ **No external tools**: pkcs11-tool, OpenSC gibi araçlara bağımlı değil
- ✅ **Cross-platform**: macOS ARM64 mimari sorunlarından etkilenmez
- ✅ **Integrated**: API'nin kendi bağımlılıklarını kullanır
- ✅ **Fast**: Spring Boot başlatmadan da çalışabilir
- ✅ **Reliable**: Java'nın native PKCS#11 implementasyonu

## [0.1.0] - 2025-11-07

### 🎉 İlk Public Release

#### Added
- 📝 **SECURITY.md** - Kapsamlı güvenlik politikası ve best practices
- 🔒 **CORS Yapılandırması** - Güvenli cross-origin resource sharing
- 🛡️ **Security Headers** - XSS, Clickjacking koruması
- 📊 **Performance Guide** - JVM tuning ve production optimizasyonu (docs/PERFORMANCE.md)
- 📚 **Örnek Projeler** - cURL (examples/)
- 🧪 **Unit Testler** - Temel servis ve controller testleri
- 📋 **CHANGELOG.md** - Versiyon geçmişi takibi

#### Changed
- ♻️ **Log Yönetimi Refactored**
  - Ana dizin yerine logback-spring.xml kullanımı
  - Yapılandırılabilir log dizini (LOG_PATH)
  - Rolling file appenders (10MB, 30 gün)
  - Ayrı error.log ve signature.log dosyaları
  - Async logging desteği hazır

- 📦 **Dependency Güncellemeleri** (JDK 1.8 uyumlu)
  - Spring Boot: 2.3.7 → 2.7.18 (LTS, güvenlik güncellemeleri)
  - Jackson: 2.11.2 → 2.15.3 (CVE düzeltmeleri)
  - BouncyCastle: 1.50 → 1.70 (güvenlik yamalarıı)
  - Apache HttpClient: 4.5.10 → 4.5.14
  - Commons Codec: 1.15 → 1.16.1
  - SpringDoc OpenAPI: 1.4.8 → 1.7.0
  - Sentry: 4.1.0 → 6.34.0
  - JSoup: 1.10.2 → 1.17.2
  - Commons Text: 1.8 → 1.11.0

- 📖 **README.md Güncellemeleri**
  - Yeni badges eklendi (Version, PRs Welcome, DSS)
  - Roadmap bölümü (v0.2.0, v0.3.0 planları)
  - Performance metrikleri
  - Güvenlik uyarıları
  - Bağımlılıklar tablosu güncellendi
  - GitHub URL'leri placeholder olarak eklendi

#### Improved
- 🚀 **Application Startup**
  - Temiz SLF4J logging (TeeOutputStream kaldırıldı)
  - Başlangıç bilgilendirme logları
  - Daha iyi hata yönetimi

- 📝 **Dokümantasyon**
  - Tüm yapılandırma dosyaları yorumlandı
  - Örnek kullanımlar ve script'ler
  - Postman koleksiyonu
  - Performance tuning rehberi

#### Security
- 🔒 CORS yapılandırması production-ready
- 🛡️ Security headers (X-Content-Type-Options, X-Frame-Options, X-XSS-Protection)
- 📋 Güvenlik politikası dokümante edildi
- ⚠️ Authentication eksikliği dokümante edildi (internal use için tasarlandı)

#### Fixed
- 🐛 Log dosyalarının ana dizinde oluşması sorunu
- 📝 application.properties syntax düzeltmeleri
- 🔧 Maven compiler encoding yapılandırması

#### Technical Debt
- ⚠️ API Authentication henüz yok (v0.2.0'da planlandı)
- ⚠️ Rate limiting henüz yok (v0.2.0'da planlandı)
- ⚠️ Docker desteği henüz yok (v0.2.0'da planlandı)

## [0.0.1] - 2025-XX-XX

### İlk İç Versiyon
- ✅ XAdES imzalama (e-Fatura, e-Arşiv, e-İrsaliye)
- ✅ PAdES imzalama
- ✅ WS-Security imzalama
- ✅ TÜBİTAK timestamp entegrasyonu
- ✅ HSM (PKCS#11) desteği
- ✅ DSS kütüphanesi custom override'ları
- ✅ OCSP/CRL cache mekanizması
- ✅ KamuSM root sertifikası desteği

---

## Versiyon Numaralandırma

Bu proje [Semantic Versioning](https://semver.org/) kullanır:

- **MAJOR** versiyon: Geriye uyumsuz API değişiklikleri
- **MINOR** versiyon: Geriye uyumlu yeni özellikler
- **PATCH** versiyon: Geriye uyumlu bug düzeltmeleri

## Kategori Açıklamaları

- **Added**: Yeni özellikler
- **Changed**: Mevcut özelliklerde değişiklikler
- **Deprecated**: Yakında kaldırılacak özellikler
- **Removed**: Kaldırılan özellikler
- **Fixed**: Bug düzeltmeleri
- **Security**: Güvenlik düzeltmeleri
- **Improved**: İyileştirmeler

## Gelecek Sürümler

### v0.2.0 (Planlanan)
- ✅ ~~Metrics (Prometheus)~~ - v0.1.0'da eklendi
- Rate limiting
- API Authentication
- Asenkron imzalama
- Batch imzalama

### v0.3.0 (Planlanan)
- CAdES imza desteği
- WebSocket bildirimler
- Kafka/RabbitMQ entegrasyonu
- Dashboard UI

