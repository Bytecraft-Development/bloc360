package live.block360.backend.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
public class HelloWorldController {

    @GetMapping("/hello")
    public String helloWorld() {
        return "Hello Test4!";
    }

}
