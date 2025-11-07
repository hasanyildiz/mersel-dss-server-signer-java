#!/bin/bash

# 🧪 Hazır Test Sertifikaları ile API Testi
# Bu script, repo içindeki test sertifikalarını kullanarak tüm API endpoint'lerini test eder

set -e

# Script scripts/ klasöründe, bu yüzden üst dizine gidiyoruz
cd "$(dirname "$0")/.." || exit 1

# Renkler
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# API URL
API_URL="${API_URL:-http://localhost:8085}"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Sign API - Test Sertifikaları ile API Testi${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# API'nin çalışıp çalışmadığını kontrol et
echo -e "${YELLOW}🔍 API bağlantısı kontrol ediliyor...${NC}"
if ! curl -s -f "${API_URL}/actuator/health" > /dev/null 2>&1; then
  echo -e "${RED}❌ API'ye bağlanılamadı: ${API_URL}${NC}"
  echo -e "${YELLOW}API'yi başlatmak için: ./scripts/quick-start-with-test-certs.sh${NC}"
  exit 1
fi
echo -e "${GREEN}✅ API çalışıyor${NC}"
echo ""

# Geçici test dizini oluştur
TEST_DIR=$(mktemp -d)
echo -e "${BLUE}📁 Test dizini: ${TEST_DIR}${NC}"
echo ""

# Test dosyaları oluştur
echo -e "${YELLOW}📝 Test dosyaları oluşturuluyor...${NC}"

# Test XML
cat > "${TEST_DIR}/test.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<TestDocument>
  <Message>Bu bir test mesajıdır</Message>
  <Timestamp>2024-11-07T12:00:00</Timestamp>
</TestDocument>
EOF

# e-Fatura Test
cat > "${TEST_DIR}/efatura.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
         xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2">
  <cbc:ID>TEST2024000001</cbc:ID>
  <cbc:IssueDate>2024-11-07</cbc:IssueDate>
  <cbc:InvoiceTypeCode>SATIS</cbc:InvoiceTypeCode>
  <cac:AccountingSupplierParty>
    <cac:Party>
      <cac:PartyName>
        <cbc:Name>Test Şirketi</cbc:Name>
      </cac:PartyName>
    </cac:Party>
  </cac:AccountingSupplierParty>
</Invoice>
EOF

# SOAP Test
cat > "${TEST_DIR}/soap.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header/>
  <soap:Body>
    <TestRequest xmlns="http://test.example.com">
      <Message>Test SOAP Message</Message>
    </TestRequest>
  </soap:Body>
</soap:Envelope>
EOF

# Minimal PDF oluştur (text2pdf yoksa text olarak)
if command -v gs &> /dev/null; then
  echo "Test PDF Document" | gs -sDEVICE=pdfwrite -o "${TEST_DIR}/test.pdf" - 2>/dev/null || true
fi

if [ ! -f "${TEST_DIR}/test.pdf" ]; then
  # Ghostscript yoksa basit bir binary PDF oluştur
  cat > "${TEST_DIR}/test.pdf" << 'EOF'
%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj
2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj
3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 612 792]
/Contents 4 0 R
/Resources <<
/Font <<
/F1 <<
/Type /Font
/Subtype /Type1
/BaseFont /Helvetica
>>
>>
>>
>>
endobj
4 0 obj
<<
/Length 44
>>
stream
BT
/F1 24 Tf
100 700 Td
(Test PDF) Tj
ET
endstream
endobj
xref
0 5
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000317 00000 n 
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
410
%%EOF
EOF
fi

echo -e "${GREEN}✅ Test dosyaları hazır${NC}"
echo ""

# Test sayacı
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test fonksiyonu
run_test() {
  local test_name=$1
  local command=$2
  
  TOTAL_TESTS=$((TOTAL_TESTS + 1))
  
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${YELLOW}Test ${TOTAL_TESTS}: ${test_name}${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  if eval "$command" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ BAŞARILI${NC}"
    PASSED_TESTS=$((PASSED_TESTS + 1))
  else
    echo -e "${RED}❌ BAŞARISIZ${NC}"
    FAILED_TESTS=$((FAILED_TESTS + 1))
  fi
  echo ""
}

# Testleri çalıştır
echo -e "${GREEN}🧪 Testler başlatılıyor...${NC}"
echo ""

# Test 1: XAdES - Genel XML imzalama
run_test "XAdES - Genel XML İmzalama" \
  "curl -s -X POST ${API_URL}/v1/xadessign \
    -F 'document=@${TEST_DIR}/test.xml' \
    -F 'documentType=None' \
    -o ${TEST_DIR}/signed-test.xml"

# Test 2: XAdES - e-Fatura imzalama
run_test "XAdES - e-Fatura İmzalama (UBL)" \
  "curl -s -X POST ${API_URL}/v1/xadessign \
    -F 'document=@${TEST_DIR}/efatura.xml' \
    -F 'documentType=UblDocument' \
    -o ${TEST_DIR}/signed-efatura.xml"

# Test 3: PAdES - PDF imzalama
if [ -f "${TEST_DIR}/test.pdf" ]; then
  run_test "PAdES - PDF İmzalama" \
    "curl -s -X POST ${API_URL}/v1/padessign \
      -F 'document=@${TEST_DIR}/test.pdf' \
      -F 'appendMode=false' \
      -o ${TEST_DIR}/signed-test.pdf"
fi

# Test 4: WS-Security - SOAP imzalama
run_test "WS-Security - SOAP 1.1 İmzalama" \
  "curl -s -X POST ${API_URL}/v1/wssecuritysign \
    -F 'document=@${TEST_DIR}/soap.xml' \
    -F 'soap1Dot2=false' \
    -o ${TEST_DIR}/signed-soap.xml"

# Test 5: Health check
run_test "Health Check Endpoint" \
  "curl -s -f ${API_URL}/actuator/health"

# Test 6: TÜBİTAK Kontör Sorgulama (eğer aktifse)
if [ "${IS_TUBITAK_TSP}" = "true" ]; then
  run_test "TÜBİTAK Kontör Sorgulama" \
    "curl -s -f ${API_URL}/api/tubitak/credit"
fi

# Özet
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📊 Test Özeti${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Toplam Test: ${TOTAL_TESTS}"
echo -e "  ${GREEN}Başarılı: ${PASSED_TESTS}${NC}"
if [ $FAILED_TESTS -gt 0 ]; then
  echo -e "  ${RED}Başarısız: ${FAILED_TESTS}${NC}"
else
  echo -e "  ${GREEN}Başarısız: ${FAILED_TESTS}${NC}"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# İmzalanmış dosyaları göster
echo -e "${YELLOW}📄 İmzalanmış Dosyalar:${NC}"
ls -lh ${TEST_DIR}/signed-* 2>/dev/null || echo "  Hiç imzalanmış dosya oluşturulamadı"
echo ""

# İmzaları doğrulama önerisi
if [ $PASSED_TESTS -gt 0 ]; then
  echo -e "${GREEN}✅ İmzalar başarıyla oluşturuldu!${NC}"
  echo ""
  echo -e "${YELLOW}💡 İmzalanmış dosyaları incelemek için:${NC}"
  echo "  cat ${TEST_DIR}/signed-test.xml"
  echo "  xmllint --format ${TEST_DIR}/signed-efatura.xml | grep Signature"
  if [ -f "${TEST_DIR}/signed-test.pdf" ]; then
    echo "  pdfinfo ${TEST_DIR}/signed-test.pdf"
  fi
fi

echo ""
echo -e "${BLUE}Test dizini: ${TEST_DIR}${NC}"
echo -e "${YELLOW}Dosyaları silmek için: rm -rf ${TEST_DIR}${NC}"
echo ""

# Başarı durumuna göre exit code
if [ $FAILED_TESTS -gt 0 ]; then
  exit 1
else
  exit 0
fi

