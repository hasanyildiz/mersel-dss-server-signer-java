#!/bin/bash
# Hızlı başlatma: Test Sertifikası 3 (testkurum3@test.com.tr)

# Script scripts/ klasöründe, bu yüzden üst dizine gidiyoruz
cd "$(dirname "$0")/.." || exit 1

export PFX_PATH=./resources/test-certs/testkurum3@test.com.tr_181193.pfx
export CERTIFICATE_PIN=181193
export CERTIFICATE_ALIAS=1
export IS_TUBITAK_TSP=false

echo "🔐 Test Sertifikası 3 ile başlatılıyor..."
echo "   Email: testkurum3@test.com.tr"
echo "   Parola: 181193"
echo ""

mvn spring-boot:run

