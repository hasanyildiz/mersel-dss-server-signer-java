package io.mersel.dss.signer.api.dtos;

import io.swagger.v3.oas.annotations.media.Schema;

/**
 * Zaman damgası alma yanıtı için DTO.
 */
@Schema(description = "Zaman damgası alma yanıtı")
public class TimestampResponseDto {

    @Schema(
        description = "Zaman damgası token'ı (RFC 3161 TST) - Base64 kodlu (internal use)",
        example = "MIIGfAYJKoZIhvcNAQcCoIIGbTCCBmkCAQMxDzANBglghkgBZQMEAgEFADCBigYLKoZIhvcNAQkQAQSgew..."
    )
    private String timestampToken;

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

    public String getTimestampToken() {
        return timestampToken;
    }

    public void setTimestampToken(String timestampToken) {
        this.timestampToken = timestampToken;
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
}

