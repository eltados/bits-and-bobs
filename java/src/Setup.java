


import java.util.HashMap;

import com.datacash.mmp.common.beans.request.AddAPMRequest;
import com.datacash.mmp.common.beans.request.AddClientRequest;
import com.datacash.mmp.common.beans.request.AddMerchantRequest;
import com.datacash.mmp.common.beans.request.AddMidRequest;
import com.datacash.mmp.common.beans.request.AddTerminalRequest;
import com.datacash.mmp.common.beans.request.AmendMerchantRequest;
import com.datacash.mmp.common.beans.request.ApproveMerchantRequest;
import com.datacash.mmp.common.beans.request.CheckPermissionRequest;
import com.datacash.mmp.common.beans.request.SubmitMerchantRequest;
import com.datacash.mmp.common.beans.response.MerchantResponse;
import com.datacash.mmp.common.beans.response.ViewMerchantResponse;
import com.datacash.mmp.common.model.Client;
import com.datacash.mmp.common.model.Merchant;
import com.datacash.mmp.common.model.MerchantSetup;
import com.datacash.mmp.common.model.Mid;
import com.datacash.mmp.common.model.Terminal;
import com.datacash.mmp.common.model.UserLevel;
import com.datacash.mmp.common.model.apm.APM;
import com.datacash.mmp.common.model.enums.Entity;
import com.datacash.mmp.test.utility.Msp;

public class Setup {

	//	private final HashMap<Class<?>, String> ids = new HashMap<Class<?>, String>();
	//	private final WebServiceClient wsClient;
	//
	//	public Setup as( String sessionToken ) throws Exception {
	//		wsClient.setSession( sessionToken );
	//		return this;
	//	}
	//
	//	public Setup as( Msp msp, UserLevel userLevel ) throws Exception {
	//		wsClient.login( msp, userLevel );
	//		return this;
	//	}
	//
	//	public static Setup connect() throws Exception {
	//		WebServiceClient wsClient = new WebServiceClient();
	//		initializeWsClient( wsClient );
	//		return new Setup( wsClient );
	//	}
	//
	//	public static Setup connect( String url ) throws Exception {
	//		WebServiceClient wsClient = new WebServiceClient( url );
	//		initializeWsClient( wsClient );
	//		return new Setup( wsClient );
	//	}
	//
	//	private static void initializeWsClient( WebServiceClient wsClient ) {
	//		wsClient.setVerify( true );
	//		wsClient.setDebug( true );
	//		wsClient.setRemoveEntityFieldsInRequests( true );
	//  }
	//
	//	public Setup( WebServiceClient client ) throws Exception {
	//		this.wsClient = client;
	//	}
	//
	//	public Setup add( Merchant merchant ) throws Exception {
	//		AddMerchantRequest request = new AddMerchantRequest();
	//		request.setMerchant( merchant );
	//
	//		String guid = wsClient.setUrl( "/merchant/add" ).post( request ).getResponse( MerchantResponse.class ).getId();
	//		ids.put( Merchant.class, guid );
	//		return this;
	//	}
	//
	//	public <T extends APM<T>> Setup add( T apm ) throws Exception {
	//		AddAPMRequest<T> request = new AddAPMRequest<T>();
	//		request.setClientGuid( getId( Client.class ) );
	//		request.setApm( apm );
	//		String guid = wsClient.setUrl( Entity.forClass( apm.getClass() ).getEntity() + "/view" ).post( request ).getResponse( MerchantResponse.class ).getId();
	//		ids.put( apm.getClass(), guid );
	//		return this;
	//	}
	//
	//
	//	public Setup add( Client client ) throws Exception {
	//		AddClientRequest request = new AddClientRequest();
	//		request.setMerchantId( getId( Merchant.class ) );
	//		request.setClient( client );
	//		String guid = wsClient.setUrl( "/merchant/card_services/client/add" ).post( request ).getResponse( MerchantResponse.class ).getId();
	//		ids.put( client.getClass(), guid );
	//		return this;
	//	}
	//
	//	public Setup add( Mid mid ) throws Exception {
	//		AddMidRequest request = new AddMidRequest();
	//		request.setClientId( getId( Client.class ) );
	//		request.setMid( mid );
	//		String guid = wsClient.setUrl( "/merchant/card_services/mid/add" ).post( request ).getResponse( MerchantResponse.class ).getId();
	//		ids.put( Mid.class, guid );
	//		return this;
	//	}
	//
	//	public Setup add( Terminal terminal ) throws Exception {
	//		AddTerminalRequest request = new AddTerminalRequest();
	//		request.setId( getId( Mid.class ) );
	//		request.setTerminal( terminal );
	//		String guid = wsClient.setUrl( "/merchant/card_services/terminal/add" ).post( request ).getResponse( MerchantResponse.class ).getId();
	//		ids.put( Terminal.class, guid );
	//		return this;
	//	}
	//
	//
	//	public String getId( Class<?> klass ) {
	//		String id = ids.get( klass );
	//		if ( id == null ) {
	//			throw new RuntimeException( "Could not find an id for the class type " + klass.getSimpleName() );
	//		}
	//		return id;
	//	}
	//
	//	public Setup delete( Class<? extends MerchantSetup> klass ) throws Exception {
	//		wsClient.setUrl( Entity.forClass( klass ).getDeleteUrl() ).delete( ids.get( klass ) );
	//		ids.remove( klass );
	//		return this;
	//	}
	//
	//	public Merchant getMerchant() throws Exception {
	//		return wsClient.setUrl( "/merchant/view" ).viewWithChildren( getId( Merchant.class ) ).getResponse( ViewMerchantResponse.class ).getMerchant();
	//	}
	//
	//
	//	public Setup submit() throws Exception {
	//		SubmitMerchantRequest request = new SubmitMerchantRequest();
	//		request.setId( getId( Merchant.class ) );
	//		wsClient.setUrl( "/merchant/submit" ).post( request );
	//		return this;
	//	}
	//
	//	public Setup approve() throws Exception {
	//		ApproveMerchantRequest request = new ApproveMerchantRequest();
	//		request.setId( getId( Merchant.class ) );
	//		wsClient.setUrl( "/merchant/approve" ).post( request );
	//		return this;
	//	}
	//
	//	public Setup runProcessor() throws Exception {
	//		MmpServiceHelper.runProcessor();
	//		return this;
	//	}
	//
	//	public Setup complete() throws Exception {
	//		return this.submit().approve().runProcessor();
	//	}
	//
	//	public Setup amend() throws Exception {
	//		AmendMerchantRequest request = new AmendMerchantRequest();
	//		request.setMerchantId( getId( Merchant.class ) );
	//		wsClient.setUrl( "/merchant/amend" ).post( request );
	//		return this;
	//	}
	//
	//	public Setup permission( String operation ) throws Exception {
	//		CheckPermissionRequest request = new CheckPermissionRequest();
	//		request.setOperation( operation );
	//		wsClient.setUrl( "/check_permission" ).post( request );
	//		return this;
	//	}
	//
	//	public static void main( String[] args ) throws Exception {
	//
	//		WebServiceClient ws = new WebServiceClient( "https://vm-201-wheezy-mpm/dc-mmp-webservice" );
	//		ws.setDebug( true );
	//		ws.setVerify( true );
	//
	//		ws.login( Msp.WL_Swedbank_Es, UserLevel.MSP_ADMIN );
	//
	//		CheckPermissionRequest request = new CheckPermissionRequest();
	//		request.setOperation( "/merchant/redecard/add" );
	//		ws.setUrl( "/check_permission" ).setRequest( "{\n" +
	//		    "  \"operation\": \"/merchant/redecard/add\",\n" +
	//		    "  \"session_token\": \"_SESSION_\"\n" +
	//		    "}" ).modifyRequest( "_SESSION_", "lol" ).post();
	//
	//
	////		    .add( ExampleData.createMerchant( 155 ) );
	////		    .add( ExampleData.createClient() )
	////		    .add( ExampleData.createSwedbankNordicMid() )
	////		    .add( ExampleData.createSwedbankNordicTerminal() )
	////		    .add( ExampleData.createDnbLithuania() );
	//		
	//		
	////		    .complete()
	////		    .amend()
	////		    .delete( Client.class )
	////		    .complete()
	////		    .getMerchant();
	//
	//	}


}
