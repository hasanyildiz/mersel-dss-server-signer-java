# PowerShell Script: Test Sertifikası 2 ile Başlatma
# testkurum02@sm.gov.tr

$ErrorActionPreference = "Stop"

# Proje root dizinine git
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent (Split-Path -Parent $scriptPath)
Set-Location $projectRoot

# Environment variables
$env:PFX_PATH = ".\resources\test-certs\testkurum02@sm.gov.tr_059025.pfx"
$env:CERTIFICATE_PIN = "059025"
$env:CERTIFICATE_ALIAS = "1"
$env:IS_TUBITAK_TSP = "false"

Write-Host "🔐 Test Sertifikası 2 ile başlatılıyor..." -ForegroundColor Green
Write-Host "   Email: testkurum02@sm.gov.tr"
Write-Host "   Parola: 059025"
Write-Host ""

# Maven'i başlat
mvn spring-boot:run

