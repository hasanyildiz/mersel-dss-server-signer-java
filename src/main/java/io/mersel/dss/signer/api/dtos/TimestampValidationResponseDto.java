package io.mersel.dss.signer.api.dtos;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

/**
 * Zaman damgası doğrulama yanıtı için DTO.
 */
@Schema(description = "Zaman damgası doğrulama yanıtı")
public class TimestampValidationResponseDto {

    @Schema(
        description = "Zaman damgası geçerli mi",
        example = "true"
    )
    private boolean valid;

    @Schema(
        description = "Zaman damgası zamanı (ISO 8601 formatında)",
        example = "2025-11-07T14:30:00Z"
    )
    private String timestamp;

    @Schema(
        description = "TSA (Time Stamp Authority) bilgisi",
        example = "CN=TÜBİTAK ESYA TSS, O=TÜBİTAK, C=TR"
    )
    private String tsaName;

    @Schema(
        description = "Kullanılan hash algoritması",
        example = "SHA256"
    )
    private String hashAlgorithm;

    @Schema(
        description = "Seri numarası",
        example = "123456789"
    )
    private String serialNumber;

    @Schema(
        description = "Nonce değeri (varsa)",
        example = "1234567890123456"
    )
    private String nonce;

    @Schema(
        description = "İmza algoritması",
        example = "SHA256withRSA"
    )
    private String signatureAlgorithm;

    @Schema(
        description = "TSA sertifikası (Base64 kodlu PEM formatında)"
    )
    private String tsaCertificate;

    @Schema(
        description = "Sertifika geçerli mi",
        example = "true"
    )
    private boolean certificateValid;

    @Schema(
        description = "Sertifika başlangıç tarihi",
        example = "2024-01-01T00:00:00Z"
    )
    private String certificateNotBefore;

    @Schema(
        description = "Sertifika bitiş tarihi",
        example = "2026-01-01T00:00:00Z"
    )
    private String certificateNotAfter;

    @Schema(
        description = "Hash doğrulaması başarılı mı (originalData sağlanmışsa)",
        example = "true"
    )
    private Boolean hashVerified;

    @Schema(
        description = "Doğrulama hataları veya uyarılar"
    )
    private List<String> errors;

    @Schema(
        description = "Doğrulama mesajı",
        example = "Zaman damgası geçerli"
    )
    private String message;

    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getTsaName() {
        return tsaName;
    }

    public void setTsaName(String tsaName) {
        this.tsaName = tsaName;
    }

    public String getHashAlgorithm() {
        return hashAlgorithm;
    }

    public void setHashAlgorithm(String hashAlgorithm) {
        this.hashAlgorithm = hashAlgorithm;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getNonce() {
        return nonce;
    }

    public void setNonce(String nonce) {
        this.nonce = nonce;
    }

    public String getSignatureAlgorithm() {
        return signatureAlgorithm;
    }

    public void setSignatureAlgorithm(String signatureAlgorithm) {
        this.signatureAlgorithm = signatureAlgorithm;
    }

    public String getTsaCertificate() {
        return tsaCertificate;
    }

    public void setTsaCertificate(String tsaCertificate) {
        this.tsaCertificate = tsaCertificate;
    }

    public boolean isCertificateValid() {
        return certificateValid;
    }

    public void setCertificateValid(boolean certificateValid) {
        this.certificateValid = certificateValid;
    }

    public String getCertificateNotBefore() {
        return certificateNotBefore;
    }

    public void setCertificateNotBefore(String certificateNotBefore) {
        this.certificateNotBefore = certificateNotBefore;
    }

    public String getCertificateNotAfter() {
        return certificateNotAfter;
    }

    public void setCertificateNotAfter(String certificateNotAfter) {
        this.certificateNotAfter = certificateNotAfter;
    }

    public Boolean getHashVerified() {
        return hashVerified;
    }

    public void setHashVerified(Boolean hashVerified) {
        this.hashVerified = hashVerified;
    }

    public List<String> getErrors() {
        return errors;
    }

    public void setErrors(List<String> errors) {
        this.errors = errors;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}

