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
    public UserRegistrationRecord createUser(@RequestBody UserRegistrationRecord user) {
        return keycloackUserService.createUser(user);
    }

    @PostMapping("/createHouseHoldUser")
    public UserRegistrationRecord createHouseHoldUser(@RequestBody UserRegistrationRecord user) {
        return keycloackUserService.createHouseHoldUser(user);
    }


    @GetMapping("/getUser")
    public UserRepresentation getUser(Principal principal) {
        return keycloackUserService.getUserById(principal.getName());
    }

}
