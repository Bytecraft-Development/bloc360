package live.bloc360.backend.controller;

import live.bloc360.backend.service.EmailServiceImpl;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EmailTestController {
    private final EmailServiceImpl emailServiceImpl;

    public EmailTestController(EmailServiceImpl emailServiceImpl) {
        this.emailServiceImpl = emailServiceImpl;
    }

    @PostMapping("/sendmail")
    public void sendTestEmail(@RequestBody String mail) {
        emailServiceImpl.sendSimpleMessage(mail, "Test email from SpringBoot", "This is a test mail");
    }

}
