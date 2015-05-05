import com.datacash.mmp.common.beans.request.Request;
import com.datacash.mmp.common.beans.response.Response;
import com.datacash.mmp.common.model.Client;
import com.datacash.mmp.common.model.Fraud;
import com.datacash.mmp.common.model.Merchant;
import com.datacash.mmp.common.model.MerchantSetup;
import com.datacash.mmp.common.model.Mid;
import com.datacash.mmp.common.model.MultiPV;
import com.datacash.mmp.common.model.Terminal;
import com.datacash.mmp.common.model.enums.Entity;
import com.datacash.mmp.common.utility.MmpOperation;

@SuppressWarnings( "rawtypes" )
public class Mapper {


	private final Class<? extends MerchantSetup> source;

	//	private Operation operation;

	private Mapper( Class<? extends MerchantSetup> clazz ) {
		this.source = clazz;
	}

	public static Mapper forClass( Class<? extends MerchantSetup> clazz ) {
		return new Mapper( clazz );
	}

	public static Mapper forURI( String uri ) {
		String baseUri = uri.replaceAll( "/(add|view|delete|edit)$", "" );
		Class<? extends MerchantSetup> clazz = Entity.forEntity( baseUri ).getKlass();
		return new Mapper( clazz );
	}

	public static Mapper forEntity( Entity entity ) {
		return new Mapper( entity.getKlass() );
	}

	public String getURL( Operation operation ) {
		return getBaseURL() + operation.getURLSuffix();
	}

	public Class<? extends MerchantSetup> getKlass() {
		return source;
	}

	public Class<? extends Request> getRequestClass( Operation operation ) {
		return operation.getRequest( source );
	}

	public Class<? extends Response> getResponseClass( Operation operation ) {
		return operation.getResponse( source );
	}

	public Entity getEntity() {
		return Entity.forClass( source );
	}

	public String getBaseURL() {
		return getEntity().getEntity();
	}






}
