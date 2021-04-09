package utilities;

import models.Reimbursement;
import models.User;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class AccountCreationEmail {
    
    private smtpEmail = System.getenv("ERS_SMTP_EMAIL");
    private smtpPassword = System.getenv("ERS_SMTP_PASSWORD");
    
    public static void sendMail(User user) throws MessagingException {
        System.out.println("Preparing to send email...");
        Properties properties = new Properties();

        properties.put("mail.smtp.auth","true");
        properties.put("mail.smtp.starttls.enable","true");
        properties.put("mail.smtp.host","smtp.gmail.com");
        properties.put("mail.smtp.port","587");

        String myaccountEmail = smtpEmail;
        String password = smtpPassword;

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(myaccountEmail,password);
            }
        });

        Message message = prepareMessage(session, myaccountEmail, user);

        Transport.send(message);
        System.out.println("Message Sent Successfully");

    }

    public static Message prepareMessage(Session session, String myAccountEmail, User user){
        try{
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(myAccountEmail));
            message.setRecipient(Message.RecipientType.TO,new InternetAddress(user.getEmail()));
            message.setSubject("Your account has been created!");
            message.setText("Username: " + user.getUsername() + "\n" +
                            "Password: " + Encryption.decrypt(user.getPassword()) + "\n" +
                            "Location: http://localhost:9001/"
                    );
            return message;
        }catch(Exception ex){
            ex.printStackTrace();
        }

        return null;
    }
}
