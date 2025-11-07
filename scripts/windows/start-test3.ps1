# PowerShell Script: Test Sertifikası 3 ile Başlatma
# testkurum3@test.com.tr

$ErrorActionPreference = "Stop"

# Proje root dizinine git
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
Set-Location $projectRoot

# Environment variables
$env:PFX_PATH = ".\resources\test-certs\testkurum3@test.com.tr_181193.pfx"
$env:CERTIFICATE_PIN = "181193"
$env:CERTIFICATE_ALIAS = "1"
$env:IS_TUBITAK_TSP = "false"

Write-Host "🔐 Test Sertifikası 3 ile başlatılıyor..." -ForegroundColor Green
Write-Host "   Email: testkurum3@test.com.tr"
Write-Host "   Parola: 181193"
Write-Host ""

# Maven'i başlat
mvn spring-boot:run

