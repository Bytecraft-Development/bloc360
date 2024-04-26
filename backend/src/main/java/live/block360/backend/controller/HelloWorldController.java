package live.block360.backend.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
public class HelloWorldController {
    @GetMapping("/hello")
    public String helloWorld(Authentication authentication) {
        Jwt aaa = (Jwt) authentication.getCredentials();
        return "Hello Bloc360Team" + ". Welcome " +  aaa.getClaims().get("name");
    }

}
