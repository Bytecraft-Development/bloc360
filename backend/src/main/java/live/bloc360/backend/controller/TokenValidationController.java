package live.bloc360.backend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class TokenValidationController {

    @GetMapping("/validate")
    public boolean validate(Authentication authentication) {
       Jwt aaa = (Jwt) authentication.getCredentials();
        return aaa != null;
    }
}
