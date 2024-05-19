package live.bloc360.backend.service;
import com.sendgrid.*;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.rmi.RemoteException;
@Service
public class EmailServiceSendGrid {
    @Value("${spring.mail.SENDGRID_API_KEY}")
    private String SendGridApiKey;

    public void sendMail(String subject, Content content) throws IOException {
        Email from = new Email("suport@bloc360.live");
        Email to = new Email("andrea.hegyesi1@gmail.com");
        Mail mail = new Mail(from, subject, to, content);

        SendGrid sg = new SendGrid(SendGridApiKey);
        Request request = new Request();
        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            Response response = sg.api(request);
            System.out.println(response.getStatusCode());
            System.out.println(response.getBody());
            System.out.println(response.getHeaders());
        } catch (IOException ex) {
            throw new RemoteException("Could not send email  " );
        }
    }
}