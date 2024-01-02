package encryption;

import java.util.Base64;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256 {
	
	public static String hash(String s) {
		String hashed = "";
		MessageDigest digest = null;
		try {
			digest = MessageDigest.getInstance("SHA-256"); //Initializes HASHING object
		}
		catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		
		byte[] hashedBytes = digest.digest(("s41t"+s).getBytes(StandardCharsets.UTF_8)); //Hashes Username and Password to bytes
		byte[] b64Bytes = Base64.getEncoder().encode(hashedBytes); //Turns bytes into base64 string. 
		hashed = new String(b64Bytes);
		
		return hashed;
	}
}
