package live.block360.backend.config;

import lombok.Value;
import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class KeyCloakConfig {


    private String adminCLientID= "admin-cli";
    private String adminCLientSecret= "o8q5j5FeLgBRTclA3j5klNhQujwG14rl";
    private String realms="bloc360";
    private String authServerUrl="https://bloc360.live:8443/";


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
