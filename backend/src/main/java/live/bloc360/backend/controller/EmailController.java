//package live.bloc360.backend.controller;
//
//import com.sendgrid.helpers.mail.objects.Content;
//import live.bloc360.backend.service.EmailServiceSendGrid;
//import lombok.SneakyThrows;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//@RestController
//public class EmailController {
//    private final EmailServiceSendGrid emailServiceSendGrid;
//
//    public EmailController(EmailServiceSendGrid emailServiceSendGrid) {
//        this.emailServiceSendGrid = emailServiceSendGrid;
//    }
//
//
//    @SneakyThrows
//    @PostMapping("/sendmail")
//    public void sendTestEmail() {
//        emailServiceSendGrid.sendMail("Test email from SpringBoot", new Content("text/plain", "and easy to do anywhere, even with Java"));
//    }
//
//}
