package io.mersel.dss.signer.api.dtos;

import io.swagger.v3.oas.annotations.media.Schema;

import javax.validation.constraints.NotBlank;

/**
 * Zaman damgası alma talebi için DTO.
 */
@Schema(description = "Zaman damgası alma talebi")
public class TimestampRequestDto {

    @NotBlank(message = "Belge verisi boş olamaz")
    @Schema(
        description = "Zaman damgası alınacak belgenin Base64 kodlu verisi",
        example = "SGVsbG8gV29ybGQ=",
        required = true
    )
    private String documentData;

    @Schema(
        description = "Hash algoritması (varsayılan: SHA256)",
        example = "SHA256",
        allowableValues = {"SHA1", "SHA224", "SHA256", "SHA384", "SHA512"}
    )
    private String hashAlgorithm = "SHA256";

    @Schema(
        description = "Nonce kullanılıp kullanılmayacağı (güvenlik için önerilir)",
        example = "true"
    )
    private Boolean useNonce = true;

    @Schema(
        description = "TSA sertifikasının istenip istenmeyeceği",
        example = "true"
    )
    private Boolean certReq = true;

    public String getDocumentData() {
        return documentData;
    }

    public void setDocumentData(String documentData) {
        this.documentData = documentData;
    }

    public String getHashAlgorithm() {
        return hashAlgorithm;
    }

    public void setHashAlgorithm(String hashAlgorithm) {
        this.hashAlgorithm = hashAlgorithm;
    }

    public Boolean getUseNonce() {
        return useNonce;
    }

    public void setUseNonce(Boolean useNonce) {
        this.useNonce = useNonce;
    }

    public Boolean getCertReq() {
        return certReq;
    }

    public void setCertReq(Boolean certReq) {
        this.certReq = certReq;
    }
}

