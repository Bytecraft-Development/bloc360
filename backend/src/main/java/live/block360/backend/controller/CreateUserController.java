package live.block360.backend.controller;

import com.sun.security.auth.UserPrincipal;
import live.block360.backend.Service.KeycloackUserService;
import live.block360.backend.model.UserRegistrationRecord;
import lombok.AllArgsConstructor;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@AllArgsConstructor
@CrossOrigin
public class CreateUserController {

    private final KeycloackUserService keycloackUserService;


    @PostMapping("/createUser")
    public UserRegistrationRecord createuser(@RequestBody UserRegistrationRecord user) {
        return keycloackUserService.createUser(user);
    }

    @GetMapping("/getUser")
    public UserRepresentation getUser(Principal principal) {
        return keycloackUserService.getUserById(principal.getName());
    }

}
