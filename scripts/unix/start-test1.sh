#!/bin/bash
# Hızlı başlatma: Test Sertifikası 1 (testkurum01@test.com.tr)

# Script scripts/ klasöründe, bu yüzden üst dizine gidiyoruz
cd "$(dirname "$0")/.." || exit 1

export PFX_PATH=./resources/test-certs/testkurum01@test.com.tr_614573.pfx
export CERTIFICATE_PIN=614573
export CERTIFICATE_ALIAS=1
export IS_TUBITAK_TSP=false

echo "🔐 Test Sertifikası 1 ile başlatılıyor..."
echo "   Email: testkurum01@test.com.tr"
echo "   Parola: 614573"
echo ""

mvn spring-boot:run

