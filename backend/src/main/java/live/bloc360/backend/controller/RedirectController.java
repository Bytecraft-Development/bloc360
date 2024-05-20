package live.bloc360.backend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.Authentication;

import java.util.List;

@RestController
@RequiredArgsConstructor
@CrossOrigin
@RequestMapping
public class RedirectController {

    @GetMapping("/redirectByRole")
    public ResponseEntity<String> redirectByRole(Authentication authentication) {
        Jwt jwt = (Jwt) authentication.getCredentials();
        List<String> roles = jwt.getClaimAsStringList("groups");
        if (roles.contains("admin")) {
            return ResponseEntity.ok("/adminDashboard");
        }
        return ResponseEntity.ok("/userDashboard");
    }

}
