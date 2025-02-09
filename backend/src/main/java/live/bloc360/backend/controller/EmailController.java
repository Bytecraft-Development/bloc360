//package live.bloc360.backend.controller;
//
//import jakarta.mail.MessagingException;
//import live.bloc360.backend.service.EmailServiceImpl;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.io.IOException;
//
//@RestController
//public class EmailController {
//    private final EmailServiceImpl emailServiceImpl;
//
//    public EmailController(EmailServiceImpl emailServiceImpl) {
//        this.emailServiceImpl = emailServiceImpl;
//    }
//
//    @PostMapping("/sendmail")
//    public ResponseEntity<String> sendEmail(@RequestBody String mail) {
//        try {
//            emailServiceImpl.sendMimeMessage(mail, "Test email from SpringBoot", "This is a test mail");
//            return ResponseEntity.ok("Email sent successfully!");
//        } catch (MessagingException e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send email: MessagingException occurred");
//        } catch (IOException e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send email: IOException occurred");
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send email: An unexpected error occurred");
//        }
//    }
//
//}
//
