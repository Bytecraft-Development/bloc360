package live.bloc360.backend.Utils;

import java.security.SecureRandom;

public class StringUtils {

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    public static String generateRandomString(int length) {
        SecureRandom secureRandom = new SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARACTERS.charAt(secureRandom.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }
}
