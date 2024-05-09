package live.bloc360.backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class KeyCloakConfig {

    @Value("${keycloak.adminClientId}")
    private String adminCLientID;

    @Value("${keycloak.adminClientSecret}")
    private String adminCLientSecret;

    @Value("${keycloak.realm}")
    private String realms;

    @Value("${keycloak.urls.auth}")
    private String authServerUrl;


    @Bean
    public Keycloak keycloak(){

        return KeycloakBuilder
                .builder()
                .serverUrl(authServerUrl)
                .realm(realms)
                .grantType(OAuth2Constants.CLIENT_CREDENTIALS)
                .clientId(adminCLientID)
                .clientSecret(adminCLientSecret)
                .build();
    }



}
