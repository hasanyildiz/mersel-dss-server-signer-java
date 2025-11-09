package io.mersel.dss.signer.api.models;

import javax.validation.constraints.NotBlank;

/**
 * Hata yanıt modeli.
 * API'den dönen standart hata formatı.
 */
public class ErrorModel {
    private String code;
    private String message;

    public ErrorModel(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    @NotBlank
    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    @NotBlank
    public void setMessage(String message) {
        this.message = message;
    }
}
