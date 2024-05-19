package live.bloc360.backend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.Authentication;

@RestController
@RequiredArgsConstructor
@CrossOrigin
@RequestMapping
public class RedirectController {

    @GetMapping("/redirectByRole")
    public ResponseEntity<String> redirectByRole(Authentication authentication) {
        Jwt jwt = (Jwt) authentication.getCredentials();
        String role = (String) jwt.getClaims().get("groups");
        if (role.contains("admin")) {
            return ResponseEntity.ok("redirect:/adminDashboard");
        }
        return ResponseEntity.ok("redirect:/userDashboard");
    }

}
