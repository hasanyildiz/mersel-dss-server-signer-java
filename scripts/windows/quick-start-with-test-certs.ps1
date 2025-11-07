# PowerShell Script: Hızlı Başlatma - Test Sertifikaları ile
# Windows için Sign API hızlı başlatma script'i

$ErrorActionPreference = "Stop"

# Renkler
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

# Script'in bulunduğu dizinden proje root'a git
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
Set-Location $projectRoot

Write-ColorOutput Cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-ColorOutput Cyan "  Sign API - Hazır Test Sertifikaları ile Başlatma"
Write-ColorOutput Cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Output ""

# Kullanılabilir sertifikalar
Write-ColorOutput Green "Kullanılabilir Test Sertifikaları:"
Write-Output ""
Write-Output "  1) testkurum01@test.com.tr (Test Kurum 1)"
Write-Output "  2) testkurum02@sm.gov.tr (Test Kurum 2)"
Write-Output "  3) testkurum3@test.com.tr (Test Kurum 3)"
Write-Output ""

# Kullanıcıdan sertifika seçimi
$certChoice = Read-Host "Hangi sertifikayı kullanmak istiyorsunuz? (1-3, varsayılan: 1)"
if ([string]::IsNullOrEmpty($certChoice)) {
    $certChoice = "1"
}

# Sertifika bilgilerini ayarla
switch ($certChoice) {
    "1" {
        $pfxFile = "testkurum01@test.com.tr_614573.pfx"
        $pfxPassword = "614573"
        $certName = "testkurum01@test.com.tr"
    }
    "2" {
        $pfxFile = "testkurum02@sm.gov.tr_059025.pfx"
        $pfxPassword = "059025"
        $certName = "testkurum02@sm.gov.tr"
    }
    "3" {
        $pfxFile = "testkurum3@test.com.tr_181193.pfx"
        $pfxPassword = "181193"
        $certName = "testkurum3@test.com.tr"
    }
    default {
        Write-ColorOutput Red "❌ Geçersiz seçim! (1-3 arası bir değer girin)"
        exit 1
    }
}

Write-Output ""
Write-ColorOutput Green "✅ Seçilen sertifika: $certName"
Write-Output ""

# PFX dosya yollarını kontrol et
$pfxPath1 = ".\resources\test-certs\$pfxFile"
$pfxPath2 = ".\src\main\resources\certs\$pfxFile"

if (Test-Path $pfxPath1) {
    $pfxPath = $pfxPath1
} elseif (Test-Path $pfxPath2) {
    $pfxPath = $pfxPath2
} else {
    Write-ColorOutput Red "❌ Hata: PFX dosyası bulunamadı!"
    Write-ColorOutput Yellow "Aranılan yerler:"
    Write-Output "  - $pfxPath1"
    Write-Output "  - $pfxPath2"
    exit 1
}

Write-ColorOutput Blue "📁 PFX Dosya Yolu: $pfxPath"
Write-Output ""

# Environment variables'ları ayarla
$env:PFX_PATH = $pfxPath
$env:CERTIFICATE_PIN = $pfxPassword
$env:CERTIFICATE_ALIAS = "1"
$env:IS_TUBITAK_TSP = "false"

# Timestamp kullanımını sor
Write-ColorOutput Yellow "TÜBİTAK Timestamp kullanmak istiyor musunuz? (y/N):"
$useTimestamp = Read-Host
if ($useTimestamp -eq "y" -or $useTimestamp -eq "Y") {
    $env:IS_TUBITAK_TSP = "true"
    Write-Output ""
    Write-ColorOutput Yellow "TÜBİTAK Timestamp Bilgileri:"
    $tsUserId = Read-Host "Kullanıcı ID"
    $tsUserPassword = Read-Host "Şifre" -AsSecureString
    $tsUserPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($tsUserPassword))
    
    $env:TS_SERVER_HOST = "http://zd.kamusm.gov.tr/"
    $env:TS_USER_ID = $tsUserId
    $env:TS_USER_PASSWORD = $tsUserPasswordPlain
    
    Write-ColorOutput Green "✅ Timestamp yapılandırması tamamlandı"
} else {
    Write-ColorOutput Yellow "⚠️  Timestamp devre dışı (test imzaları)"
}

Write-Output ""
Write-ColorOutput Cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-ColorOutput Green "Yapılandırma Özeti:"
Write-ColorOutput Cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Output "  Sertifika:           $certName"
Write-Output "  PFX Yolu:            $pfxPath"
Write-Output "  Sertifika Alias:     1"
Write-Output "  Timestamp:           $($env:IS_TUBITAK_TSP)"
Write-ColorOutput Cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-ColorOutput Red "⚠️  UYARI: Test sertifikası ile çalışıyorsunuz!"
Write-ColorOutput Red "   Bu sertifikalar SADECE geliştirme/test içindir - Production'da kullanmayın!"
Write-ColorOutput Cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Output ""

# Maven kontrolü
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-ColorOutput Red "❌ Maven bulunamadı! Lütfen Maven'i yükleyin."
    exit 1
}

# Başlatma seçeneği
Write-ColorOutput Yellow "Başlatma Modu:"
Write-Output "  1) Spring Boot ile çalıştır (önerilen)"
Write-Output "  2) Sadece environment variables'ları göster"
Write-Output ""
$startMode = Read-Host "Seçiminiz (1-2, varsayılan: 1)"
if ([string]::IsNullOrEmpty($startMode)) {
    $startMode = "1"
}

if ($startMode -eq "2") {
    Write-Output ""
    Write-ColorOutput Green "📋 Manuel başlatma için komutlar:"
    Write-Output ""
    Write-ColorOutput Blue "# Environment variables:"
    Write-Output "`$env:PFX_PATH = `"$pfxPath`""
    Write-Output "`$env:CERTIFICATE_PIN = `"$pfxPassword`""
    Write-Output "`$env:CERTIFICATE_ALIAS = `"1`""
    Write-Output "`$env:IS_TUBITAK_TSP = `"$($env:IS_TUBITAK_TSP)`""
    if ($env:IS_TUBITAK_TSP -eq "true") {
        Write-Output "`$env:TS_SERVER_HOST = `"$($env:TS_SERVER_HOST)`""
        Write-Output "`$env:TS_USER_ID = `"$($env:TS_USER_ID)`""
        Write-Output "`$env:TS_USER_PASSWORD = `"$($env:TS_USER_PASSWORD)`""
    }
    Write-Output ""
    Write-ColorOutput Blue "# Başlatma:"
    Write-Output "mvn spring-boot:run"
    Write-Output ""
    exit 0
}

Write-Output ""
Write-ColorOutput Green "🚀 Sign API başlatılıyor..."
Write-Output ""

# Uygulamayı başlat
mvn spring-boot:run

