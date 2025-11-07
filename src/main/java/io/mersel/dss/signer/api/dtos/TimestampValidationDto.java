package io.mersel.dss.signer.api.dtos;

import io.swagger.v3.oas.annotations.media.Schema;

import javax.validation.constraints.NotBlank;

/**
 * Zaman damgası doğrulama talebi için DTO.
 */
@Schema(description = "Zaman damgası doğrulama talebi")
public class TimestampValidationDto {

    @NotBlank(message = "Zaman damgası token'ı boş olamaz")
    @Schema(
        description = "Doğrulanacak zaman damgası token'ı (Base64 kodlu)",
        example = "MIIGfAYJKoZIhvcNAQcCoIIGbTCCBmkCAQMxDzANBglghkgBZQMEAgEFADCBigYLKoZIhvcNAQkQAQSgew...",
        required = true
    )
    private String timestampToken;

    @Schema(
        description = "Orijinal belge verisi (Base64 kodlu) - hash doğrulaması için",
        example = "SGVsbG8gV29ybGQ="
    )
    private String originalData;

    public String getTimestampToken() {
        return timestampToken;
    }

    public void setTimestampToken(String timestampToken) {
        this.timestampToken = timestampToken;
    }

    public String getOriginalData() {
        return originalData;
    }

    public void setOriginalData(String originalData) {
        this.originalData = originalData;
    }
}

