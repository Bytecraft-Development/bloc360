package live.bloc360.backend.config;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@Getter
public class KeyCloakConfig {

    @Value("${keycloak.adminClientId}")
    private String adminCLientID;

    @Value("${keycloak.adminClientSecret}")
    private String adminCLientSecret;

    @Value("${keycloak.realm}")
    private String realm;

    @Value("${keycloak.urls.auth}")
    private String authServerUrl;


    @Bean
    public Keycloak keycloak(){

        return KeycloakBuilder
                .builder()
                .serverUrl(authServerUrl)
                .realm(realm)
                .grantType(OAuth2Constants.CLIENT_CREDENTIALS)
                .clientId(adminCLientID)
                .clientSecret(adminCLientSecret)
                .build();
    }



}
