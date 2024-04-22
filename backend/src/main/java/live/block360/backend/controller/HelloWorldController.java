package live.block360.backend.controller;

import org.springframework.context.annotation.Profile;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
@Profile("security")
public class HelloWorldController {

    @GetMapping("/hello")
    public String helloWorld() {
        return "Hello 16 aprilie 2024";
    }

}
