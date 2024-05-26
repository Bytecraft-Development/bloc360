package live.bloc360.backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoders;
import org.springframework.security.oauth2.server.resource.authentication.DelegatingJwtGrantedAuthoritiesConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    @Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri}")
    String issuerUrl;

    @Bean
    public SecurityFilterChain configure(HttpSecurity http) throws Exception {

        DelegatingJwtGrantedAuthoritiesConverter authoritiesConverter =
                new DelegatingJwtGrantedAuthoritiesConverter(
                        new JwtGrantedAuthoritiesConverter(),
                        new KeycloakJwtRolesConverter());

        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests((authorize) -> authorize
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        .requestMatchers("/sendmail").hasRole("realm_system")
                        .requestMatchers("/validate").hasRole("realm_user")
                        .requestMatchers("/**").permitAll()
                        .anyRequest().authenticated())
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .oauth2ResourceServer((oauth2) -> oauth2
                        .jwt((c) -> c.jwtAuthenticationConverter(jwt -> new JwtAuthenticationToken(jwt, authoritiesConverter.convert(jwt)))));

        return http.build();
    }

    @Bean
    public JwtDecoder jwtDecoder() {
        return JwtDecoders.fromIssuerLocation(issuerUrl);
    }

}
