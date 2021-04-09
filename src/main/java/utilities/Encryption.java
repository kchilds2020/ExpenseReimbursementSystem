package utilities;

import org.jasypt.util.text.BasicTextEncryptor;
import org.jasypt.util.text.TextEncryptor;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.security.Key;

/**
 * Custom Encryption for project 1
 * */
public class Encryption {

    /**
     * encrypts string
     * */
    public static String encrypt(String password) {
        BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
        textEncryptor.setPassword("supersecretpassword");
        return textEncryptor.encrypt(password);
    }

    /**
     * decrypts string
     * */
    public static String decrypt(String enc) {
        BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
        textEncryptor.setPassword("supersecretpassword");
        return textEncryptor.decrypt(enc);
    }
}
