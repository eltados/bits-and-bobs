import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;


public class Obfuscate {

	private static final String DEFAULT_SALT = "klsdiuydiushdfiuyiuy54237jbdshds";

	public static String toGuid( int id ) {
		return toGuid( id, DEFAULT_SALT );
	}

	public static Integer fromGuid( String guid ) {
		return fromGuid( guid, DEFAULT_SALT );
	}

	public static boolean isValidGuid( String guid ) {
		return isValidGuid( guid, DEFAULT_SALT );
	}
	public static String toGuid( int id, String salt ) {
		String paddedId = StringUtils.leftPad( String.valueOf( Integer.MAX_VALUE - id ), 12, "0" );
		String sha = DigestUtils.shaHex( paddedId + salt );
		return sha.substring( 0, 8 ) + "-" + sha.substring( 8, 12 ) + "-" + sha.substring( 12, 16 ) + "-" + sha.substring( 16, 20 ) + "-" + paddedId;
	}

	public static Integer fromGuid( String guid, String salt ) throws IllegalArgumentException {
		Integer id = null;
		if ( guid == null || salt == null || guid.length() < 36 ) {
			throw new IllegalArgumentException( "Invalid guid" );
		}
		try {
			id = Integer.MAX_VALUE - Integer.parseInt( guid.substring( 24, 36 ) );
		}
		catch ( NumberFormatException e ) {
			throw new IllegalArgumentException( "Invalid guid" );
		}
		if ( !guid.equals( toGuid( id, salt ) ) ) {
			throw new IllegalArgumentException( "Invalid guid" );
		}
		return id;
	}

	public static boolean isValidGuid( String guid, String salt ) {
		try{
			fromGuid( guid, salt );
		}catch ( IllegalArgumentException e ) {
			return false;
		}
		return true;
	}
}
