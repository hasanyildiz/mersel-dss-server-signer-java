package io.mersel.dss.signer.api.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web güvenlik yapılandırması.
 * 
 * Not: Bu proje şu anda authentication olmadan çalışmaktadır.
 * Internal kullanım için tasarlanmıştır. Production ortamında
 * network seviyesinde güvenlik sağlanmalıdır.
 */
@Configuration
public class SecurityConfiguration implements WebMvcConfigurer {

    @Value("${cors.allowed-origins:*}")
    private String allowedOrigins;

    @Value("${cors.allowed-methods:GET,POST,PUT,DELETE,OPTIONS}")
    private String allowedMethods;

    @Value("${cors.max-age:3600}")
    private Long maxAge;

    /**
     * Root path'i Swagger UI'ya yönlendir.
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addRedirectViewController("/", "/index.html");
    }

    /**
     * CORS mapping configuration.
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS", "HEAD", "PATCH")
                .allowedHeaders("*")
                .exposedHeaders(
                    "x-signature-value",
                    "Content-Disposition",
                    "X-Timestamp-Time",
                    "X-Timestamp-TSA",
                    "X-Timestamp-Serial",
                    "X-Timestamp-Hash-Algorithm"
                )
                .allowCredentials(false)
                .maxAge(3600);
    }

}

