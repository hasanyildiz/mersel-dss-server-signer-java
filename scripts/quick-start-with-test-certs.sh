#!/bin/bash

# 🚀 Hazır Test Sertifikaları ile Hızlı Başlatma
# Bu script, repo içindeki test PFX sertifikaları ile Sign API'yi başlatır

set -e

# Script scripts/ klasöründe, bu yüzden üst dizine gidiyoruz
cd "$(dirname "$0")/.." || exit 1

# Renkler
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Sign API - Hazır Test Sertifikaları ile Başlatma${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Kullanılabilir sertifikalar
echo -e "${GREEN}Kullanılabilir Test Sertifikaları:${NC}"
echo ""
echo -e "  ${YELLOW}1)${NC} testkurum01@test.com.tr (Test Kurum 1)"
echo -e "  ${YELLOW}2)${NC} testkurum02@sm.gov.tr (Test Kurum 2)"
echo -e "  ${YELLOW}3)${NC} testkurum3@test.com.tr (Test Kurum 3)"
echo ""

# Kullanıcıdan sertifika seçimini al
read -p "$(echo -e ${GREEN}Hangi sertifikayı kullanmak istiyorsunuz? \(1-3, varsayılan: 1\): ${NC})" cert_choice
cert_choice=${cert_choice:-1}

# Sertifika bilgilerini ayarla
case $cert_choice in
  1)
    PFX_FILE="testkurum01@test.com.tr_614573.pfx"
    PFX_PASSWORD="614573"
    CERT_NAME="testkurum01@test.com.tr"
    ;;
  2)
    PFX_FILE="testkurum02@sm.gov.tr_059025.pfx"
    PFX_PASSWORD="059025"
    CERT_NAME="testkurum02@sm.gov.tr"
    ;;
  3)
    PFX_FILE="testkurum3@test.com.tr_181193.pfx"
    PFX_PASSWORD="181193"
    CERT_NAME="testkurum3@test.com.tr"
    ;;
  *)
    echo -e "${RED}❌ Geçersiz seçim! (1-3 arası bir değer girin)${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${GREEN}✅ Seçilen sertifika: ${CERT_NAME}${NC}"
echo ""

# PFX dosya yollarını kontrol et
PFX_PATH_1="./resources/test-certs/${PFX_FILE}"
PFX_PATH_2="./src/main/resources/certs/${PFX_FILE}"

if [ -f "$PFX_PATH_1" ]; then
  PFX_PATH="$PFX_PATH_1"
elif [ -f "$PFX_PATH_2" ]; then
  PFX_PATH="$PFX_PATH_2"
else
  echo -e "${RED}❌ Hata: PFX dosyası bulunamadı!${NC}"
  echo -e "${YELLOW}Aranılan yerler:${NC}"
  echo "  - $PFX_PATH_1"
  echo "  - $PFX_PATH_2"
  exit 1
fi

echo -e "${BLUE}📁 PFX Dosya Yolu: ${PFX_PATH}${NC}"
echo ""

# Environment variables'ları export et
export PFX_PATH="$PFX_PATH"
export CERTIFICATE_PIN="$PFX_PASSWORD"
export CERTIFICATE_ALIAS=1  # PFX dosyalarında alias olarak "1" kullanılıyor
export IS_TUBITAK_TSP=false  # Test için timestamp devre dışı

# Timestamp kullanımını sor
echo -e "${YELLOW}TÜBİTAK Timestamp kullanmak istiyor musunuz? (y/N):${NC}"
read -p "> " use_timestamp
use_timestamp=${use_timestamp:-n}

if [[ "$use_timestamp" =~ ^[Yy]$ ]]; then
  export IS_TUBITAK_TSP=true
  echo ""
  echo -e "${YELLOW}TÜBİTAK Timestamp Bilgileri:${NC}"
  read -p "Kullanıcı ID: " ts_user_id
  read -sp "Şifre: " ts_user_password
  echo ""
  
  export TS_SERVER_HOST=http://zd.kamusm.gov.tr/
  export TS_USER_ID="$ts_user_id"
  export TS_USER_PASSWORD="$ts_user_password"
  
  echo -e "${GREEN}✅ Timestamp yapılandırması tamamlandı${NC}"
else
  echo -e "${YELLOW}⚠️  Timestamp devre dışı (test imzaları)${NC}"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Yapılandırma Özeti:${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Sertifika:           ${YELLOW}${CERT_NAME}${NC}"
echo -e "  PFX Yolu:            ${YELLOW}${PFX_PATH}${NC}"
echo -e "  Sertifika Alias:     ${YELLOW}1${NC}"
echo -e "  Timestamp:           ${YELLOW}${IS_TUBITAK_TSP}${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}⚠️  UYARI: Test sertifikası ile çalışıyorsunuz!${NC}"
echo -e "${RED}   Bu sertifikalar SADECE geliştirme/test içindir - Production'da kullanmayın!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Maven'in kurulu olup olmadığını kontrol et
if ! command -v mvn &> /dev/null; then
  echo -e "${RED}❌ Maven bulunamadı! Lütfen Maven'i yükleyin.${NC}"
  exit 1
fi

# Başlatma seçeneği
echo -e "${YELLOW}Başlatma Modu:${NC}"
echo -e "  ${YELLOW}1)${NC} Spring Boot ile çalıştır (önerilen)"
echo -e "  ${YELLOW}2)${NC} Sadece environment variables'ları göster"
echo ""
read -p "$(echo -e ${GREEN}Seçiminiz \(1-2, varsayılan: 1\): ${NC})" start_mode
start_mode=${start_mode:-1}

if [ "$start_mode" == "2" ]; then
  echo ""
  echo -e "${GREEN}📋 Manuel başlatma için komutlar:${NC}"
  echo ""
  echo -e "${BLUE}# Environment variables:${NC}"
  echo "export PFX_PATH=\"$PFX_PATH\""
  echo "export CERTIFICATE_PIN=\"$PFX_PASSWORD\""
  echo "export CERTIFICATE_ALIAS=1"
  echo "export IS_TUBITAK_TSP=$IS_TUBITAK_TSP"
  if [[ "$use_timestamp" =~ ^[Yy]$ ]]; then
    echo "export TS_SERVER_HOST=\"$TS_SERVER_HOST\""
    echo "export TS_USER_ID=\"$TS_USER_ID\""
    echo "export TS_USER_PASSWORD=\"$TS_USER_PASSWORD\""
  fi
  echo ""
  echo -e "${BLUE}# Başlatma:${NC}"
  echo "mvn spring-boot:run"
  echo ""
  exit 0
fi

echo ""
echo -e "${GREEN}🚀 Sign API başlatılıyor...${NC}"
echo ""

# Uygulamayı başlat
mvn spring-boot:run

