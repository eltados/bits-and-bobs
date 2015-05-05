import org.apache.commons.lang.StringUtils;


public class StringInflector {

	private final String source;
	

	public StringInflector( String source ) {
		this.source = source;
	}

	public StringInflector( Class<?> clazz ) {
		this.source = clazz.getSimpleName();
	}

	public static StringInflector from( Class<?> clazz ) {
		return new StringInflector( clazz );
	}

	public static StringInflector from( String source ) {
		return new StringInflector( source );
	}

	public String toUnderscore() {
		return StringUtils.lowerCase( StringUtils.join( StringUtils.splitByCharacterTypeCamelCase( source ), '_' ) );
	}

	public String toDotted() {
		return StringUtils.lowerCase( StringUtils.join( StringUtils.splitByCharacterTypeCamelCase( source ), '.' ) );
	}

	public String toConstant() {
		return StringUtils.upperCase( StringUtils.join( StringUtils.splitByCharacterTypeCamelCase( source ), '_' ) );
	}

	public String toHumanReadable() {
		return StringUtils.join( StringUtils.splitByCharacterTypeCamelCase( source ), ' ' );
	}

}
