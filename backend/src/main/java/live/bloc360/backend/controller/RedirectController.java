package live.bloc360.backend.controller;

import live.bloc360.backend.model.Association;
import live.bloc360.backend.service.AssociationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.Authentication;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@CrossOrigin
@RequestMapping
public class RedirectController {

    private final AssociationService associationService;

    @GetMapping("/redirectByRole")
    public ResponseEntity<String> redirectByRole(Authentication authentication) {
        Jwt jwt = (Jwt) authentication.getPrincipal();
        List<String> roles = jwt.getClaimAsStringList("groups"); // Sau "roles" în funcție de configurare

        if (roles.contains("admin")) {
            String adminUsername = jwt.getClaimAsString("preferred_username"); // Sau "sub" sau alt claim specific
            Optional<Association> association = associationService.findByAdminUsername(adminUsername);
            if (association.isPresent()) {
                return ResponseEntity.ok("/dashboard");
            } else {
                return ResponseEntity.ok("/createAssociation");
            }
        } else {
            return ResponseEntity.ok("/dashboard");
        }
    }

}
