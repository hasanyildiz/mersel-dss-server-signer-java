#!/bin/bash
# Hızlı başlatma: Test Sertifikası 2 (testkurum02@sm.gov.tr)

# Script scripts/ klasöründe, bu yüzden üst dizine gidiyoruz
cd "$(dirname "$0")/.." || exit 1

export PFX_PATH=./resources/test-certs/testkurum02@sm.gov.tr_059025.pfx
export CERTIFICATE_PIN=059025
export CERTIFICATE_ALIAS=1
export IS_TUBITAK_TSP=false

echo "🔐 Test Sertifikası 2 ile başlatılıyor..."
echo "   Email: testkurum02@sm.gov.tr"
echo "   Parola: 059025"
echo ""

mvn spring-boot:run

