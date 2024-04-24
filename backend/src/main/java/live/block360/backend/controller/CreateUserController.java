package live.block360.backend.controller;

import live.block360.backend.Service.KeycloackUserService;
import live.block360.backend.model.UserRegistrationRecord;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@CrossOrigin
public class CreateUserController {

    private final KeycloackUserService keycloackUserService;


    @PostMapping("/createUser")
    public UserRegistrationRecord createuser(@RequestBody UserRegistrationRecord user) {
        return keycloackUserService.createUser(user);
    }

}
