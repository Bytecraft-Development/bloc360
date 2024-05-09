package live.bloc360.backend.controller;

import live.bloc360.backend.model.UserRegistrationRecord;
import live.bloc360.backend.service.KeycloackUserService;
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
