#!/bin/bash
# 📊 Grafana Metrics Load Test
# Bu script çeşitli API endpoint'lerini çağırarak Prometheus/Grafana için metrik üretir
# RSA ve EC384 sertifikaları ile test yapabilir

set -e

API_URL=${API_URL:-http://localhost:8085}
ITERATIONS=${ITERATIONS:-10}
SLEEP_BETWEEN=${SLEEP_BETWEEN:-1}

echo "📊 Grafana Metrics Load Test"
echo "================================"
echo "🎯 API URL: $API_URL"
echo "🔄 İterasyonlar: $ITERATIONS"
echo "⏱️  Bekleme süresi: ${SLEEP_BETWEEN}s"
echo ""

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Başarı/hata sayaçları
SUCCESS_COUNT=0
ERROR_COUNT=0
TOTAL_REQUESTS=0

# Script dizinini bul (resources/test-documents'e erişmek için)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DOCS_DIR="$PROJECT_ROOT/resources/test-documents"

# Test dosyası oluştur (basit bir PDF)
create_test_pdf() {
    cat > /tmp/test.pdf << 'EOF'
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
/Resources <<
/Font <<
/F1 <<
/Type /Font
/Subtype /Type1
/BaseFont /Helvetica
>>
>>
>>
/MediaBox [0 0 612 792]
/Contents 4 0 R
>>
endobj
4 0 obj
<<
/Length 44
>>
stream
BT
/F1 12 Tf
100 700 Td
(Test Document) Tj
ET
endstream
endobj
xref
0 5
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000324 00000 n 
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
417
%%EOF
EOF
}

# API çağrısı yap ve metrik topla
call_api() {
    local endpoint=$1
    local method=${2:-GET}
    local data=$3
    local name=$4
    local extra_params=$5
    
    TOTAL_REQUESTS=$((TOTAL_REQUESTS + 1))
    
    printf "${BLUE}[%3d/%3d]${NC} %-45s " "$TOTAL_REQUESTS" "$((ITERATIONS * 8))" "$name"
    
    start_time=$(date +%s%N)
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$API_URL$endpoint" 2>&1)
    elif [ "$method" = "POST" ] && [ -n "$data" ]; then
        if [ -n "$extra_params" ]; then
            # XAdES gibi endpoint'ler için ekstra parametreler
            # eval kullanarak extra_params'ı doğru expand et
            response=$(eval curl -s -w \"\\n%{http_code}\" -X POST \"$API_URL$endpoint\" \
                -F \"document=@$data\" \
                $extra_params 2>&1)
        else
            # PDF gibi basit upload'lar için
            response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL$endpoint" \
                -F "document=@$data" 2>&1)
        fi
    else
        response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL$endpoint" 2>&1)
    fi
    
    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
        printf "${GREEN}✓${NC} %4dms [%s]\n" "$duration" "$http_code"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        printf "${RED}✗${NC} %4dms [%s]\n" "$duration" "$http_code"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
}

# Test dosyalarını oluştur
echo "🔧 Test dosyaları hazırlanıyor..."
create_test_pdf

# Test dokümanlarını kontrol et
if [ ! -f "$TEST_DOCS_DIR/EFATURA.xml" ]; then
    echo -e "${RED}⚠️  e-Fatura dosyası bulunamadı: $TEST_DOCS_DIR/EFATURA.xml${NC}"
    exit 1
fi

if [ ! -f "$TEST_DOCS_DIR/soap-1.1-envelope.xml" ]; then
    echo -e "${RED}⚠️  SOAP 1.1 envelope dosyası bulunamadı: $TEST_DOCS_DIR/soap-1.1-envelope.xml${NC}"
    exit 1
fi

if [ ! -f "$TEST_DOCS_DIR/soap-1.2-envelope.xml" ]; then
    echo -e "${RED}⚠️  SOAP 1.2 envelope dosyası bulunamadı: $TEST_DOCS_DIR/soap-1.2-envelope.xml${NC}"
    exit 1
fi

echo "✓ e-Fatura: $TEST_DOCS_DIR/EFATURA.xml"
echo "✓ SOAP 1.1 envelope: $TEST_DOCS_DIR/soap-1.1-envelope.xml"
echo "✓ SOAP 1.2 envelope: $TEST_DOCS_DIR/soap-1.2-envelope.xml"
echo ""

# Ana test döngüsü
echo "🚀 Test başlatılıyor..."
echo ""

for i in $(seq 1 $ITERATIONS); do
    echo -e "${YELLOW}━━━ İterasyon $i/$ITERATIONS ━━━${NC}"
    
    # 1. Health Check
    call_api "/actuator/health" "GET" "" "Health Check"
    
    # 2. Metrics Endpoint
    call_api "/actuator/prometheus" "GET" "" "Prometheus Metrics"
    
    # 3. Certificate Info (RSA veya EC384 - dinamik)
    call_api "/api/certificates/info" "GET" "" "Certificate Info (RSA/EC384)"
    
    # 4. PDF Signing (RSA veya EC384 - SHA256withRSA/ECDSA)
    call_api "/v1/padessign" "POST" "/tmp/test.pdf" "PDF Sign (RSA/EC384 Dynamic)"
    
    # 5. XAdES Signing (EFATURA.xml ile)
    call_api "/v1/xadessign" "POST" "$TEST_DOCS_DIR/EFATURA.xml" "XAdES Sign e-Fatura (RSA/EC384)" '-F "documentType=UblDocument"'
    
    # 6. SOAP 1.1 WS-Security Signing
    call_api "/v1/wssecuritysign" "POST" "$TEST_DOCS_DIR/soap-1.1-envelope.xml" "SOAP 1.1 Sign (RSA/EC384)" '-F "soap1Dot2=false"'
    
    # 7. SOAP 1.2 WS-Security Signing
    call_api "/v1/wssecuritysign" "POST" "$TEST_DOCS_DIR/soap-1.2-envelope.xml" "SOAP 1.2 Sign (RSA/EC384)" '-F "soap1Dot2=true"'
    
    # 8. Invalid endpoint (404 hatası generate et)
    call_api "/v1/invalid-endpoint-$(date +%s)" "GET" "" "Invalid Endpoint (404 error)"
    
    echo ""
    
    # Bekleme
    if [ $i -lt $ITERATIONS ]; then
        sleep $SLEEP_BETWEEN
    fi
done

# Özet
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Test Özeti"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Toplam İstek:  $TOTAL_REQUESTS"
echo -e "${GREEN}Başarılı:      $SUCCESS_COUNT${NC}"
echo -e "${RED}Hatalı:        $ERROR_COUNT${NC}"
SUCCESS_RATE=$(awk "BEGIN {printf \"%.1f\", ($SUCCESS_COUNT/$TOTAL_REQUESTS)*100}")
echo "Başarı Oranı:  ${SUCCESS_RATE}%"
echo ""
echo "🎯 Grafana'da görebileceğin metrikler:"
echo "  • HTTP Request Rate (requests/sec)"
echo "  • Response Time (p50, p95, p99)"
echo "  • Error Rate (4xx, 5xx)"
echo "  • Active Requests"
echo "  • JVM Memory Usage"
echo "  • GC Activity"
echo "  • Signature Algorithm (RSA vs EC384)"
echo "  • SOAP 1.1 vs SOAP 1.2 imzalama"
echo ""
echo -e "📈 Grafana: ${BLUE}http://localhost:3000${NC}"
echo -e "   Dashboard ID: ${YELLOW}11378${NC} (Spring Boot 2.x)"
echo "   Kullanıcı: admin / admin"
echo ""
echo -e "🔍 Prometheus: ${BLUE}http://localhost:9090${NC}"
echo "   Query örnekleri:"
echo "   • http_server_requests_seconds_count"
echo "   • http_server_requests_seconds_sum"
echo "   • jvm_memory_used_bytes"
echo ""
echo "📄 Test Dosyaları:"
echo "   • PDF: /tmp/test.pdf (otomatik oluşturuluyor)"
echo "   • XAdES: resources/test-documents/EFATURA.xml"
echo "   • SOAP 1.1: resources/test-documents/soap-1.1-envelope.xml"
echo "   • SOAP 1.2: resources/test-documents/soap-1.2-envelope.xml"
echo ""
echo "💡 İpucu: Farklı sertifikalarla test yapmak için:"
echo -e "   ${YELLOW}# RSA 2048 ile test${NC}"
echo "   cd devops/docker && ./unix/start-test-kurum1.sh"
echo "   bash devops/monitoring/load-test.sh"
echo ""
echo -e "   ${YELLOW}# EC384 ile test${NC}"
echo "   docker-compose down && ./unix/start-test-kurum2.sh"
echo "   bash devops/monitoring/load-test.sh"
echo ""

# Temizlik
rm -f /tmp/test.pdf

exit 0

