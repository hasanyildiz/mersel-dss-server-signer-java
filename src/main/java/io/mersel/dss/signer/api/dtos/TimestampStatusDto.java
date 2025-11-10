package io.mersel.dss.signer.api.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;

/**
 * Timestamp servisi durum bilgisi DTO.
 */
@Schema(description = "Timestamp servisi durum bilgisi")
public class TimestampStatusDto {

    @Schema(description = "Servisin yapılandırılmış ve kullanılabilir olup olmadığı", example = "true")
    @JsonProperty("configured")
    private boolean configured;

    @Schema(description = "Durum mesajı", example = "Timestamp servisi aktif")
    @JsonProperty("message")
    private String message;

    public TimestampStatusDto() {
    }

    public TimestampStatusDto(boolean configured, String message) {
        this.configured = configured;
        this.message = message;
    }

    public boolean isConfigured() {
        return configured;
    }

    public void setConfigured(boolean configured) {
        this.configured = configured;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}

