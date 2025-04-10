//package live.bloc360.backend.service;
//
//import jakarta.mail.*;
//import jakarta.mail.internet.*;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.mail.javamail.JavaMailSender;
//import org.springframework.stereotype.Component;
//
//import java.io.File;
//import java.io.IOException;
//import java.util.Properties;
//
//@Component
//public class EmailServiceImpl {
//
//    @Value("${spring.mail.username}")
//    private String username;
//
//    @Value("${spring.mail.password}")
//    private String password;
//
//    @Autowired
//    private JavaMailSender emailSender;
//
//    public void sendMimeMessage(
//            String to, String subject, String text) throws MessagingException, IOException {
//
//        Properties prop = new Properties();
//        prop.put("mail.smtp.auth", "true");
//        prop.put("mail.smtp.ssl.enable", "true");
//        prop.put("mail.smtp.socketFactory.port", "465");
//        prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
//        prop.put("mail.smtp.socketFactory.fallback", "false");
//        prop.put("mail.smtp.host", "bloc360.ro");
//        prop.put("mail.smtp.port", "465");
//
//        Session session = Session.getInstance(prop, new Authenticator() {
//            @Override
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(username, password);
//            }
//        });
//
//        Message message = new MimeMessage(session);
//        message.setFrom(new InternetAddress("noreply@bloc360.ro"));
//        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
//        message.setSubject(subject);
//
//        MimeBodyPart mimeBodyPart = new MimeBodyPart();
//        mimeBodyPart.setContent(text, "text/html; charset=utf-8");
//
//        Multipart multipart = new MimeMultipart();
//        multipart.addBodyPart(mimeBodyPart);
//
//        MimeBodyPart attachmentBodyPart = new MimeBodyPart();
//        attachmentBodyPart.attachFile(new File("outputPdf360.pdf"));
//        multipart.addBodyPart(attachmentBodyPart);
//
//        message.setContent(multipart);
//
//        Transport.send(message);
//
//    }
//}
