import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import junit.framework.Assert;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.junit.Ignore;
import org.junit.Test;
import org.springframework.util.ReflectionUtils;

import com.datacash.mmp.common.beans.request.AddMerchantRequest;
import com.datacash.mmp.common.beans.request.AddRequestFor;
import com.datacash.mmp.common.beans.request.AuthenticatedRequest;
import com.datacash.mmp.common.beans.request.DeleteMerchantRequest;
import com.datacash.mmp.common.beans.request.ViewRequest;
import com.datacash.mmp.common.beans.response.MerchantResponse;
import com.datacash.mmp.common.beans.response.ViewMerchantResponse;
import com.datacash.mmp.common.model.Client;
import com.datacash.mmp.common.model.Cv2Avs;
import com.datacash.mmp.common.model.Merchant;
import com.datacash.mmp.common.model.MerchantSetup;
import com.datacash.mmp.common.model.Parcelado;
import com.datacash.mmp.common.model.RedecardMid;
import com.datacash.mmp.common.model.enums.Entity;
import com.datacash.mmp.common.utility.MmpConstants;
import com.datacash.mmp.test.utils.ExampleData;
import com.datacash.mmp.test.utils.WebServiceClient;
import com.datacash.webservice.api.WebserviceClient;

// import static com.datacash.mmp.test.utils.ExampleData.createBoletoBancario;
// import static com.datacash.mmp.test.utils.RequestTools.serializeRequest;

// import static com.datacash.mmp.ui.utils.ExampleData.createClient;
// import static com.datacash.mmp.ui.utils.ExampleData.createMerchant;
// import static com.datacash.mmp.ui.utils.ExampleData.createTokenization;

public class TestClass {

	@Test
	public void test3() throws Exception {
		System.out.println( new SelectBuilder()
		    .column( "ch.acquirer" )
		    .column( "bf.cur AS trading_currency" )
		    .column( "base_currency_details.decimal_places AS trading_currency_dp" )
		    .column( "mm.currency AS master_merchant_currency" )
		    .column( "mm_currency_details.decimal_places AS master_merchant_currency_dp" )
		    .column( "SUM(bf.amount) AS trading_amount_total" )
		    .column( "vt.company_name" )
		    .column( "vt.vtid" )
		    .from( "tx_subject_to_control_batch stc" )
		    .join( "batchfile bf ON bf.batchnum = stc.batchnum" )
		    .leftJoin( "AppConfig.getInstance().getConfigBean().getMerchantConfDBName()" + ".master_merchant_mid_account mma ON mma.mid_id = stc.mid_id" )
		    .leftJoin( "AppConfig.getInstance().getConfigBean().getMerchantConfDBName()" + ".master_merchant mm ON mma.master_merchant_id = mm.master_merchant_id" )
		    .leftJoin( "AppConfig.getInstance().getConfigBean().getMerchantConfDBName()" + ".vterm vt ON vt.vtid = bf.batchfile_vtid" )
		    .leftJoin( "shared_system_config.currency base_currency_details ON base_currency_details.alpha_code = bf.cur" )
		    .leftJoin( "shared_system_config.currency mm_currency_details ON mm_currency_details.alpha_code = mm.currency" )
		    .leftJoin( "batchmap bm on bf.batchnum = bm.batchnum" )
		    .leftJoin( "shared_system_config.clearinghouse ch on (ch.clearinghouse, ch.mode) = (SELECT ch1.clearinghouse, ch1.mode FROM shared_system_config.clearinghouse ch1 WHERE ch1.clearinghouse = bf.clearinghouse LIMIT 1)" )
		    .where( "stc.status = ?" )
		    .where( "ch.acquirer = ?" )
		    .groupBy( "vt.vtid" )
		    .groupBy( "vt.company_name" )
		    .groupBy( "bf.cur" )
		    .groupBy( "mm.currency" )
		    .orderBy( "vt.company_name ASC" )
		    .orderBy( "mm.currency" )
		    .orderBy( "bf.cur" ).toString() );
	}

	//	@Test
	//	public void test4() throws Exception {
	//
	//		Merchant merchant = new Merchant();
	//		merchant.setId( "Id1" );
	//		merchant.setRegisteredCompanyName( "registeredCompanyName" );
	//
	//		Client client = new Client();
	//		client.setId( "Id2" );
	//		client.setOutletName( "setOutletName" );
	//
	//		ElavonUSMid elavonMid = new ElavonUSMid();
	//		elavonMid.setId( "Id3" );
	//		elavonMid.setMid( "84015005105" );
	//
	//		ElavonUSTerminal elavonTerminal = new ElavonUSTerminal();
	//		elavonTerminal.setId( "Id4" );
	//		elavonTerminal.setTerminalNumber( "99999999" );
	//
	//		Terminal terminal = new Terminal();
	//		terminal.setId( "Id5" );
	//		terminal.setTradingCurrency( "setTradingCurrency" );
	//
	//		Mid mid = new Mid();
	//		mid.setId( "Id5" );
	//		mid.setMid( "MID" );
	//		mid.setLocationCode( "Location" );
	//
	//		LinkedList<NamedObject> list = new LinkedList<NamedObject>();
	//		//		list.add( merchant );
	//		//		list.add( client );
	//		//		list.add( elavonMid );
	//		//		list.add( elavonTerminal );
	//		//		list.add( terminal );
	//		list.add( mid );
	//
	//		String json = GsonFactory.getGsonInstance().toJson( list, NamedObjectAdapter.LIST_OF_NAMED_OBJECTS );
	//		System.out.println( json );
	//
	//		LinkedList<NamedObject> list2 = GsonFactory.getGsonInstance().fromJson( json, NamedObjectAdapter.LIST_OF_NAMED_OBJECTS );
	//		assertEquals( 5, list2.size() );
	//		assertEquals( "merchant", list2.get( 0 ).getType() );
	//		assertEquals( "registeredCompanyName", list2.get( 0 ).getDisplayName() );
	//		assertEquals( "Id1", list2.get( 0 ).getId() );
	//
	//		assertEquals( "client", list2.get( 1 ).getType() );
	//		assertEquals( "setOutletName", list2.get( 1 ).getDisplayName() );
	//		assertEquals( "Id2", list2.get( 1 ).getId() );
	//
	//	}

	//	@Test
	//	public void test3() throws Exception {
	//
	//		String redecardJson = JSON(
	//		    "fulfill_limit", "100",
	//		    "merchant_name", "Merchant Name",
	//		    "merchant_city", "Merchant City",
	//		    "merchant_state_country", "GBR",
	//		    "merchant_dba_name", "Merchant DBA",
	//		    "acquirer", "redecard",
	//		    "mid", "123456789",
	//		    "clearinghouse", "redecard",
	//		    "country", "GBR",
	//		    "merchant_category_code", "1234" );
	//
	//		Mid mid = GsonFactory.getGsonInstance().fromJson( redecardJson, Mid.class );
	//		assertEquals( RedecardMid.class, mid.getClass() );
	//
	//		RedecardMid redecardMid = GsonFactory.getGsonInstance().fromJson( redecardJson, RedecardMid.class );
	//		assertEquals( RedecardMid.class, redecardMid.getClass() );
	//
	//		String midJson = JSON(
	//		    "fulfill_limit", "100",
	//		    "merchant_name", "Merchant Name",
	//		    "merchant_city", "Merchant City",
	//		    "merchant_state_country", "GBR",
	//		    "merchant_dba_name", "Merchant DBA",
	//		    "acquirer", "test",
	//		    "mid", "123456789",
	//		    "clearinghouse", "test",
	//		    "country", "GBR",
	//		    "merchant_category_code", "1234" );
	//
	//		mid = GsonFactory.getGsonInstance().fromJson( midJson, Mid.class );
	//		assertEquals( Mid.class, mid.getClass() );
	//
	//		redecardMid = GsonFactory.getGsonInstance().fromJson( midJson, RedecardMid.class );
	//		assertEquals( RedecardMid.class, redecardMid.getClass() );
	//
	//		String emptyJson = JSON();
	//
	//		mid = GsonFactory.getGsonInstance().fromJson( emptyJson, Mid.class );
	//		assertEquals( Mid.class, mid.getClass() );
	//
	//	}

	//
	//	class Animal {
	//
	//		public String getName() {
	//			return "animal";
	//		}
	//	}


	//	@Test
	//	public void test2() {
	//		System.out.println( StringUtils.difference( "hello world\ntest", "Hello Word\ntest" ) );
	//
	//	}

	//	@Test
	//	public void testSerializingEntity() {
	//
	//		Client client = createClient();
	//		client.addService( new Parcelado() );
	//		client.addService( createTokenization() );
	//		Merchant merchant = createMerchant();
	//		merchant.addClient( client );
	//
	//		String json = GsonFactory.getGsonInstance().toJson( merchant );
	//
	//		Assert.assertEquals( "/merchant", getField( json, "entity" ).getAsString() );
	//		Assert.assertEquals( "/merchant/card_services/client", getField( json, "clients", 0, "entity" ).getAsString() );
	//		Assert.assertEquals( "/merchant/card_services/parcelado", getField( json, "clients", 0, "services", 0, "entity" ).getAsString() );
	//		Assert.assertEquals( "/merchant/card_services/tokenization", getField( json, "clients", 0, "services", 1, "entity" ).getAsString() );
	//		Assert.assertEquals( "40 character token", getField( json, "clients", 0, "services", 1, "token_format" ).getAsString() );
	//
	//		Merchant fromJsonMerchant = GsonFactory.getGsonInstance().fromJson( json, Merchant.class );
	//
	//		Assert.assertEquals( json, GsonFactory.getGsonInstance().toJson( fromJsonMerchant ) );
	//		Assert.assertEquals( merchant.getClients().get( 0 ).toString(), fromJsonMerchant.getClients().get( 0 ).toString() );
	//		Assert.assertEquals( Parcelado.class, fromJsonMerchant.getClients().get( 0 ).getServices().get( 0 ).getClass() );
	//		Assert.assertEquals( Tokenization.class, fromJsonMerchant.getClients().get( 0 ).getServices().get( 1 ).getClass() );
	//
	//	}
	//
	//	@Test
	//	public void testSerializingTokenization() {
	//		String json = GsonFactory.getGsonInstance().toJson( createTokenization() );
	//		Assert.assertEquals( "40 character token", getField( json, "token_format" ).getAsString() );
	//		Assert.assertEquals( "/merchant/card_services/tokenization", getField( json, "entity" ).getAsString() );
	//	}
	//
	//	@Test
	//	public void testDeserializingTokenization() {
	//		String json = GsonFactory.getGsonInstance().toJson( createTokenization() );
	//
	//		Tokenization service = GsonFactory.getGsonInstance().fromJson( json, Tokenization.class );
	//		Assert.assertTrue( service instanceof Tokenization );
	//		Assert.assertEquals( "40 character token", service.getTokenFormat() );
	//
	//		service = (Tokenization) GsonFactory.getGsonInstance().fromJson( json, Service.class );
	//		Assert.assertTrue( service instanceof Tokenization );
	//		Assert.assertEquals( "40 character token", service.getTokenFormat() );
	//	}
	//
	//	@Test
	//	public void testDeserializingTokenizationWithoutEntityField() {
	//		String json = GsonFactory.getGsonInstance().toJson( createTokenization() );
	//		Assert.assertEquals( "The entity field should be present", "/merchant/card_services/tokenization", getField( json, "entity" ).getAsString() );
	//		json = removeEntityFields( json );
	//		Assert.assertEquals( "The entity fields should have been removed", null, getField( json, "entity" ) );
	//
	//		Tokenization service = GsonFactory.getGsonInstance().fromJson( json, Tokenization.class );
	//		Assert.assertTrue( service instanceof Tokenization );
	//		Assert.assertEquals( "40 character token", service.getTokenFormat() );
	//
	//		service = (Tokenization) GsonFactory.getGsonInstance().fromJson( json, Service.class );
	//		Assert.assertTrue( service instanceof Tokenization );
	//		Assert.assertEquals( "40 character token", service.getTokenFormat() );
	//	}
	//
	//	protected static String removeEntityFields( String json ) {
	//	  json = json.replaceAll( ",\n( *)\"entity\": \".*\n", "" );
	//	  return json;
	//  }
	//
	//
	//	public static JsonElement getField( String json, Object ... paths ) {
	//		return getField( new JsonParser().parse( json ), paths );
	//	}
	//
	//	/*
	//	 * This helper allows us to do "xpath" style 
	//	 * navigation on a JsonElement Object
	//	 * 
	//	 * */
	//	public static JsonElement getField( JsonElement jsonObject, Object ... paths ) {
	//		JsonElement child;
	//		if(paths[0] instanceof Integer){
	//			child = jsonObject.getAsJsonArray().get( (Integer) paths[0] );
	//		}else{
	//			child = jsonObject.getAsJsonObject().get( paths[0].toString() );
	//		}
	//		if ( paths.length == 1 ) {
	//			return child;
	//		}else{
	//			List<Object> newList = new ArrayList<Object>( Arrays.asList( paths ) );
	//			newList.remove( 0 );
	//			return getField( child, newList.toArray() );
	//		}
	//		
	//	}

	//	@Test
	//	public void test() {
	//
	//		BinRangeControl binRangeControl = new BinRangeControl();
	//		binRangeControl.setTarget( new Target( TargetType.MERCHANT, "100" ) );
	//		binRangeControl.setRejectRanges( Arrays.asList( new Range( 15, 200 ) ) );
	//
	//		MacConfigurator mac = new MacConfigurator();
	//		mac.add( binRangeControl );
	//		mac.delete( binRangeControl.getId() );
	//		mac.update( binRangeControl );
	//
	//		BinRangeControl bin = mac.view( 1, BinRangeControl.class );
	//
	//	}
	//
	//	public class MacConfigurator {
	//
	//		public Integer add( Control control ) {
	//			return null;
	//		}
	//
	//		public MacResponse delete( Integer id ) {
	//			return null;
	//		}
	//
	//		public MacResponse update( Control control ) {
	//			return null;
	//		}
	//
	//		public <T extends Control> T view( Integer id, Class<T> klass ) {
	//			return null;
	//		}
	//
	//		public Control view( Integer id ) {
	//			return view( id, Control.class );
	//		}
	//
	//		private MacResponse send( String message ) {
	//			return null;
	//		}
	//
	//	}
	//	
	//	
	//	class MacConfiguratorException(){
	//		
	//	}

	//	@Test
	//	public void test() throws Exception {
	//		Profile.getInstance().start();
	//
	//		doSomethingShort( 0 );
	//
	//		doSomethingLong();
	//		Profile.getInstance().close();
	//		Profile p = Profile.getInstance();
	//
	//		System.out.println( p.toReport() );
	//
	//	}
	//
	//	private void doSomethingShort( int i ) throws Exception {
	//		Profile.getInstance().start();
	//		Thread.sleep( 50 );
	//		if(i< 5){
	//			doSomethingShort( i + 1 );
	//		}
	//		Profile.getInstance().close();
	//	}
	//
	//	private void doSomethingLong() throws Exception {
	//		Profile.getInstance().start();
	//		Thread.sleep( 400 );
	//		for ( int i = 0 ; i < 5 ; i++ ) {
	//			doSomethingShort( 2 );
	//		}
	//		Profile.getInstance().close();
	//	}

	//	@Test
	//	public void test() throws Exception {
	//
	//		Merchant m = ExampleData.createMerchant();
	//		m.setRegisteredCompanyName( m.getRegisteredCompanyName() + new Date().getTime() );
	//		Client c = ExampleData.createClient();
	//		RedecardMid mid = ExampleData.createRedecardMid();
	//
	//		m.addService( ExampleData.createMac() );
	//		mid.setMid( (new Date().getTime() + "").substring( 4, 13 ) );
	//		mid.addTerminal( ExampleData.createRedecardTerminal() );
	//		c.addMid( mid );
	//		c.addService( new Parcelado() );
	//		c.addService( createBoletoBancario() );
	//		m.addClient( c );
	//		m.addClient( ExampleData.createClient() );
	//
	//		Merchant m2 = createMerchant( m );
	//
	//		System.out.println( GsonFactory.getGsonInstance().toJson( m2 ) );
	//
	//	}
	//
	//	private Merchant createMerchant( Merchant merchant ) throws Exception {
	//		
	//		String guid = create( merchant, null );
	//
	//		WebServiceClient webServiceClient = new WebServiceClient( "https://vm-204-wheezy-mpm/dc-mmp-webservice" );
	//		webServiceClient.setSession( "397224D019CAA9A29A947D1D240D8BBC" );
	//
	//		webServiceClient.setUrl( "/merchant/view" ).viewWithChildren( guid );
	//
	//		return webServiceClient.getResponse( ViewMerchantResponse.class ).getMerchant();
	//
	//	}
	//
	//	public static MmpOperation getMmpOperation( String value ) {
	//			for ( MmpOperation op : MmpOperation.values() ) {
	//				if ( op.getOperation().equals( value ) ) {
	//					return op;
	//				}
	//			}
	//		return null;
	//	}
	//
	//	private String create( MerchantSetup merchantSetup, String parentGuid ) throws Exception {
	//		System.out.println( "Creating " + merchantSetup.getClass() );
	//		 String baseUrl = Entity.getEntityForClass( merchantSetup.getClass() );
	//		 if(merchantSetup instanceof Mid){
	//			baseUrl = "/merchant/card_services/mid";
	//		 }
	//
	//		AddRequestFor addRequest = (AddRequestFor) getMmpOperation( baseUrl + "/add" ).getWsRequestClass().newInstance();
	//		addRequest.setObject( merchantSetup );
	//
	//		if ( merchantSetup instanceof Client ) {
	//			((AddClientRequest) addRequest).setMerchantId( parentGuid );
	//		}
	//		if ( merchantSetup instanceof Mid ) {
	//			((AddMidRequest) addRequest).setClientId( parentGuid );
	//		}
	//		if ( addRequest instanceof AddMerchantServiceRequest ) {
	//			((AddMerchantServiceRequest) addRequest).setMerchantGuid( parentGuid );
	//		}
	//		if ( addRequest instanceof AddTerminalRequest ) {
	//			((AddTerminalRequest) addRequest).setId( parentGuid );
	//		}
	//		if ( addRequest instanceof AddClientServiceRequest ) {
	//			((AddClientServiceRequest) addRequest).setClientGuid( parentGuid );
	//		}
	//		WebServiceClient webServiceClient = new WebServiceClient( "https://vm-204-wheezy-mpm/dc-mmp-webservice" );
	//		addRequest.setSessionToken( "397224D019CAA9A29A947D1D240D8BBC" );
	//		webServiceClient.setRequest( (Request) addRequest );
	//
	//		webServiceClient.setUrl( baseUrl + "/add" );
	//
	//		webServiceClient.setDebug( true );
	//		webServiceClient.setVerify( true );
	//		String id = webServiceClient.post().getResponse( MerchantResponse.class ).getId();
	//
	//		if ( merchantSetup != null ) {
	//			for ( Object children : merchantSetup.getChildren() ) {
	//				create( (MerchantSetup) children, id );
	//			}
	//		}
	//
	//		return id;
	//
	//	}
	
	
	//
	//		@Test
	//		public void test() throws Exception {
	//
	//		//		List<CardScheme> cardSchemes = Arrays.asList( new CardScheme( 1, "Visa" ), new CardScheme( 1, "Mastercard" ) );
	//		//
	//		//		ListMacCardSchemesResponse response = new ListMacCardSchemesResponse();
	//		//
	//		//		response.setCardSchemes( cardSchemes );
	//		//
	//		//		response.setSuccessful( true );
	//		//
	//		//		GsonFactory.getGsonInstance().toJson( response );
	//
	//		String originalJson = "{\r\n" +
	//		    "  \"entity\": \"/mac/control/card_type\",\r\n" +
	//		    "  \"card_scheme_ids\": [\r\n" +
	//		    "    7,\r\n" +
	//		    "    10\r\n" +
	//		    "  ],\r\n" +
	//		    "  \"blocking_card_types\": [\r\n" +
	//		    "    \"corporate\",\r\n" +
	//		    "    \"unknown\"\r\n" +
	//		    "  ]\r\n" +
	//		    "}";
	//		System.out.println( originalJson );
	//		System.out.println( "------" );
	//		String newJson = convert( originalJson, new Closure() {
	//		
	//			@Override
	//			public void execute( Object json ) {
	//				JsonObject jsonObject = (JsonObject) json;
	//				if ( jsonObject.has( "card_scheme_ids" ) ) {
	//
	//					Iterator<JsonElement> iter = jsonObject.get( "card_scheme_ids" ).getAsJsonArray().iterator();
	//					List<Integer> ids = new ArrayList<Integer>();
	//					while ( iter.hasNext() ) {
	//						ids.add( iter.next().getAsInt() );
	//					}
	//					JsonArray cardSchemes = new JsonArray();
	//
	//					for ( int id : ids ) {
	//						JsonObject cardScheme = new JsonObject();
	//						cardScheme.addProperty( "id", id );
	//						cardSchemes.add( cardScheme );
	//					}
	//
	//					jsonObject.add( "card_schemes", cardSchemes );
	//					jsonObject.remove( "card_scheme_ids" );
	//				}
	//			
	//		}
	//	} );
	//	 
	//	 
	//	System.out.println(newJson);	
	//		
	//		}
	//		
	//	private static String convert( String json, Closure closure ) {
	//		JsonElement jsonObject = new JsonParser().parse( json );
	//		closure.execute( jsonObject.getAsJsonObject() );
	//		return GsonFactory.getGsonInstance().toJson( jsonObject );
	//
	//		}
	
	

	//	@Test
	//	public void test() throws Exception {
	//		List<CardScheme> schemes = Arrays.asList( null, new CardScheme( 6, null ), new CardScheme( 1, "Visa" ), new CardScheme( 2, "Mastercard" ) );
	//		
	//		
	//		List<String> value = $( schemes )
	//		    .reject( x( "getDisplayName" ), eq( "Visa" ) )
	//		    .select( "getId", eq( 2 ) )
	//		    .map( "getDisplayName" )
	//		    .map( "toLowerCase" )
	//		    .toList( String.class );
	//		
	//
	//		System.out.println( value );
	//
	//		System.out.println( $( schemes ).find( "getDisplayName", eq( "Lol" ) ) );
	//		System.out.println( $( schemes ).find( "getDisplayName", eq( "Visa" ) ) );
	//		System.out.println( "=>" + $( schemes ).removeNulls( "getDisplayName" ).toHash( x( "getId" ), x( "getDisplayName" ) ) );
	//
	//		System.out.println(
	//		    $( schemes )
	//		        .select( "getDisplayName", not( eq( "Visa" ) ) )
	//		        .map( "getDisplayName" ).toList( String.class ) );
	//
	//		List<String> validSchemes =
	//		    $( schemes ).select( "getDisplayName", not( eq( null ) ) ).map( "getDisplayName" ).done( String.class );
	//
	//		System.out.println( validSchemes );
	//
	//		System.out.println(
	//		    $( schemes )
	//		        .reject( "getDisplayName", eq( null ) )
	//		        .toHash( x( "getId" ), x( "getDisplayName" ) ) );
	//
	//		System.out.println( validSchemes );
	//		
	//		System.out.println(
	//		    $( "lol", "Lol", "Mathieu", "lol", null )
	//		        .removeNulls()
	//		        .uniq()
	//		        .sort( "toLowerCase" )
	//		        .reverse()
	//		        .done()
	//		    );
	//		
	//	}
	//
	//	@Test
	//	public void test2() throws Exception {
	//		Exec add = Exec.add( ExampleData.createMerchant() );
	//		System.out.println( add.getAddUrl() );
	//		System.out.println( serializeRequest( add.generateRequest( "merchant", "client", "mid", "term" ) ) );
	//
	//		add = Exec.add( ExampleData.createClient() );
	//		System.out.println( add.getAddUrl() );
	//		System.out.println( serializeRequest( add.generateRequest( "merchant", "client", "mid", "term" ) ) );
	//
	//		add = Exec.add( ExampleData.createAiic() );
	//		System.out.println( add.getAddUrl() );
	//		System.out.println( serializeRequest( add.generateRequest( "merchant", "client", "mid", "term" ) ) );
	//
	//		//		add = Exec.add( ExampleData.createSwedbankEstoniaTerminal() );
	//		//		System.out.println( add.getAddUrl() );
	//		//		System.out.println( serializeRequest( add.generateRequest( "merchant", "client", "mid", "term" ) ) );
	//
	//		add = Exec.add( ExampleData.createHcc() );
	//		System.out.println( add.getAddUrl() );
	//		System.out.println( serializeRequest( add.generateRequest( "merchant", "client", "mid", "term" ) ) );
	//
	//		add = Exec.add( ExampleData.createThreeDeeSecureMidMastercard() );
	//		System.out.println( add.getAddUrl() );
	//		System.out.println( serializeRequest( add.generateRequest( "merchant", "client", "mid", "term" ) ) );
	//
	//		add = Exec.add( ExampleData.createBoletoBancario() );
	//		System.out.println( add.getAddUrl() );
	//		System.out.println( serializeRequest( add.generateRequest( "merchant", "client", "mid", "term" ) ) );
	//	}

	
	//	@Test
	//	public void test2() throws Exception {
	//
	//		long startTime = System.currentTimeMillis();
	//		int numberOfRequests = 100000;
	//		for ( int i = 0 ; i < numberOfRequests ; i++ ) {
	//			ViewMerchantResponse response = GsonFactory.getGsonInstance().fromJson( getJson( numberOfRequests ), ViewMerchantResponse.class );
	//			response.getMerchant().getRegisteredCompanyName();
	//		}
	//		long endTime = System.currentTimeMillis();
	//		long duration = (endTime - startTime);
	//		System.out.println( duration / 1000 + "s" );
	//		System.out.println( numberOfRequests * 1000 / duration + " look up per second" );
	//
	//	}
	//
	//	private String getJson( int numberOfRequests ) {
	//	  return  "{\r\n" +
	//		    "  \"merchant\": {\r\n" +
	//		    "    \"registered_company_number\": \"PI7745H4CK\",\r\n" +
	//		    "    \"registered_company_name\": \"Merchant 1409048137 " + numberOfRequests + "\",\r\n" +
	//		    "    \"trading_as\": \"Pizza Shack\",\r\n" +
	//		    "    \"website_address\": \"http://www.example.com/pizza_shack\",\r\n" +
	//		    "    \"market_sector\": \"Hospitality\",\r\n" +
	//		    "    \"merchant_category_code\": \"1234\",\r\n" +
	//		    "    \"overall_status\": \"Unsubmitted\",\r\n" +
	//		    "    \"boarded\": true,\r\n" +
	//		    "    \"clients\": [\r\n" +
	//		    "      {\r\n" +
	//		    "        \"reseller_name\": \"DataCash\",\r\n" +
	//		    "        \"refunds_for_winnings\": false,\r\n" +
	//		    "        \"outlet_name\": \"Pizza Shack\",\r\n" +
	//		    "        \"velocity\": \"120\",\r\n" +
	//		    "        \"mids\": [\r\n" +
	//		    "          {\r\n" +
	//		    "            \"fulfill_limit\": \"100\",\r\n" +
	//		    "            \"merchant_name\": \"Merchant Name\",\r\n" +
	//		    "            \"merchant_city\": \"Merchant City\",\r\n" +
	//		    "            \"merchant_state_country\": \"GBR\",\r\n" +
	//		    "            \"merchant_dba_name\": \"Merchant DBA\",\r\n" +
	//		    "            \"acquirer\": \"redecard\",\r\n" +
	//		    "            \"mid\": \"509335381\",\r\n" +
	//		    "            \"clearinghouse\": \"redecard\",\r\n" +
	//		    "            \"trading_currencies\": [\r\n" +
	//		    "              \"BRL\"\r\n" +
	//		    "            ],\r\n" +
	//		    "            \"settling_currency\": \"BRL\",\r\n" +
	//		    "            \"country\": \"GBR\",\r\n" +
	//		    "            \"time_zone\": \"Europe/London\",\r\n" +
	//		    "            \"merchant_category_code\": \"1234\",\r\n" +
	//		    "            \"terminals\": [\r\n" +
	//		    "              {\r\n" +
	//		    "                \"trading_currency\": \"BRL\",\r\n" +
	//		    "                \"environments\": [\r\n" +
	//		    "                  \"ecomm\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"card_schemes\": [\r\n" +
	//		    "                  \"mastercard\",\r\n" +
	//		    "                  \"visa\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"id\": \"1e2dc19c-2f58-42dd-93b6-e14b39ff6c85\",\r\n" +
	//		    "                \"status\": \"Completed\",\r\n" +
	//		    "                \"entity\": \"/merchant/card_services/terminal\"\r\n" +
	//		    "              },\r\n" +
	//		    "              {\r\n" +
	//		    "                \"trading_currency\": \"BRL\",\r\n" +
	//		    "                \"environments\": [\r\n" +
	//		    "                  \"ecomm\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"card_schemes\": [\r\n" +
	//		    "                  \"mastercard\",\r\n" +
	//		    "                  \"visa\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"id\": \"6f94c7aa-88de-4b08-9e82-7e493319295b\",\r\n" +
	//		    "                \"status\": \"Completed\",\r\n" +
	//		    "                \"entity\": \"/merchant/card_services/terminal\"\r\n" +
	//		    "              },\r\n" +
	//		    "              {\r\n" +
	//		    "                \"trading_currency\": \"BRL\",\r\n" +
	//		    "                \"environments\": [\r\n" +
	//		    "                  \"cnp\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"card_schemes\": [\r\n" +
	//		    "                  \"mastercard\",\r\n" +
	//		    "                  \"hipercard\",\r\n" +
	//		    "                  \"maestro\",\r\n" +
	//		    "                  \"debitmastercard\",\r\n" +
	//		    "                  \"delta\",\r\n" +
	//		    "                  \"electron\",\r\n" +
	//		    "                  \"amex\",\r\n" +
	//		    "                  \"diners\",\r\n" +
	//		    "                  \"elo\",\r\n" +
	//		    "                  \"visa\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"id\": \"d50540d5-bff8-4bab-a38b-6cf9dd81ce2c\",\r\n" +
	//		    "                \"status\": \"Completed\",\r\n" +
	//		    "                \"entity\": \"/merchant/card_services/terminal\"\r\n" +
	//		    "              }\r\n" +
	//		    "            ],\r\n" +
	//		    "            \"id\": \"6ab86ecc-ec47-4c24-8a55-aeb22ad2dc5e\",\r\n" +
	//		    "            \"status\": \"Completed\",\r\n" +
	//		    "            \"entity\": \"/merchant/card_services/mid/redecard\"\r\n" +
	//		    "          },\r\n" +
	//		    "          {\r\n" +
	//		    "            \"fulfill_limit\": \"100\",\r\n" +
	//		    "            \"merchant_name\": \"Merchant Name\",\r\n" +
	//		    "            \"merchant_city\": \"Merchant City\",\r\n" +
	//		    "            \"merchant_state_country\": \"GBR\",\r\n" +
	//		    "            \"merchant_dba_name\": \"Merchant DBA\",\r\n" +
	//		    "            \"acquirer\": \"redecard\",\r\n" +
	//		    "            \"mid\": \"648336835\",\r\n" +
	//		    "            \"clearinghouse\": \"redecard\",\r\n" +
	//		    "            \"trading_currencies\": [\r\n" +
	//		    "              \"BRL\"\r\n" +
	//		    "            ],\r\n" +
	//		    "            \"settling_currency\": \"BRL\",\r\n" +
	//		    "            \"country\": \"GBR\",\r\n" +
	//		    "            \"time_zone\": \"Europe/London\",\r\n" +
	//		    "            \"merchant_category_code\": \"1234\",\r\n" +
	//		    "            \"terminals\": [\r\n" +
	//		    "              {\r\n" +
	//		    "                \"trading_currency\": \"BRL\",\r\n" +
	//		    "                \"environments\": [\r\n" +
	//		    "                  \"ecomm\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"card_schemes\": [\r\n" +
	//		    "                  \"mastercard\",\r\n" +
	//		    "                  \"visa\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"id\": \"2a10e8fd-264a-44fc-b183-1bc8cc716889\",\r\n" +
	//		    "                \"status\": \"Completed\",\r\n" +
	//		    "                \"entity\": \"/merchant/card_services/terminal\"\r\n" +
	//		    "              },\r\n" +
	//		    "              {\r\n" +
	//		    "                \"trading_currency\": \"BRL\",\r\n" +
	//		    "                \"environments\": [\r\n" +
	//		    "                  \"ecomm\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"card_schemes\": [\r\n" +
	//		    "                  \"mastercard\",\r\n" +
	//		    "                  \"visa\"\r\n" +
	//		    "                ],\r\n" +
	//		    "                \"id\": \"e13866ef-98f5-4d55-bfb7-a27c009340d8\",\r\n" +
	//		    "                \"status\": \"Completed\",\r\n" +
	//		    "                \"entity\": \"/merchant/card_services/terminal\"\r\n" +
	//		    "              }\r\n" +
	//		    "            ],\r\n" +
	//		    "            \"id\": \"a3efa955-5d7e-474c-b7d2-ab83e9238fa9\",\r\n" +
	//		    "            \"status\": \"Completed\",\r\n" +
	//		    "            \"entity\": \"/merchant/card_services/mid/redecard\"\r\n" +
	//		    "          }\r\n" +
	//		    "        ],\r\n" +
	//		    "        \"services\": [\r\n" +
	//		    "          {\r\n" +
	//		    "            \"service\": \"Airlines Transaction\",\r\n" +
	//		    "            \"id\": \"5bd7a6ad-e155-41aa-aecf-02dc24489858\",\r\n" +
	//		    "            \"status\": \"Completed\",\r\n" +
	//		    "            \"entity\": \"/merchant/card_services/airlines_transaction\"\r\n" +
	//		    "          },\r\n" +
	//		    "          {\r\n" +
	//		    "            \"service\": \"MultiPV\",\r\n" +
	//		    "            \"id\": \"dcbc226b-376b-4678-9123-a1e68e1f2026\",\r\n" +
	//		    "            \"status\": \"Completed\",\r\n" +
	//		    "            \"entity\": \"/merchant/card_services/multipv\"\r\n" +
	//		    "          },\r\n" +
	//		    "          {\r\n" +
	//		    "            \"service\": \"Parcelado\",\r\n" +
	//		    "            \"id\": \"0d347da1-6c1d-4c33-8b88-0ae00100ff3b\",\r\n" +
	//		    "            \"status\": \"Completed\",\r\n" +
	//		    "            \"entity\": \"/merchant/card_services/parcelado\"\r\n" +
	//		    "          },\r\n" +
	//		    "          {\r\n" +
	//		    "            \"subscription_types\": [\r\n" +
	//		    "              \"visa\",\r\n" +
	//		    "              \"mastercard\"\r\n" +
	//		    "            ],\r\n" +
	//		    "            \"message_expiry\": \"7200\",\r\n" +
	//		    "            \"referral_expiry\": \"21600\",\r\n" +
	//		    "            \"service\": \"3D Secure\",\r\n" +
	//		    "            \"id\": \"07f2b5c1-e4f0-4301-8e9c-bd7d04eda262\",\r\n" +
	//		    "            \"status\": \"Completed\",\r\n" +
	//		    "            \"entity\": \"/merchant/card_services/3dsecure\"\r\n" +
	//		    "          }\r\n" +
	//		    "        ],\r\n" +
	//		    "        \"id\": \"67273cd0-da88-41eb-a6c6-63fb7d0a0ed3\",\r\n" +
	//		    "        \"status\": \"Completed\",\r\n" +
	//		    "        \"entity\": \"/merchant/card_services/client\"\r\n" +
	//		    "      }\r\n" +
	//		    "    ],\r\n" +
	//		    "    \"controls\": [\r\n" +
	//		    "      {\r\n" +
	//		    "        \"control_details\": {\r\n" +
	//		    "          \"entity\": \"/mac/control/3ds_required\",\r\n" +
	//		    "          \"environment\": [\r\n" +
	//		    "            \"ecomm\"\r\n" +
	//		    "          ]\r\n" +
	//		    "        },\r\n" +
	//		    "        \"id\": \"969960e3-73ee-4b31-bbcd-5bac7bffdca5\",\r\n" +
	//		    "        \"status\": \"Completed\",\r\n" +
	//		    "        \"entity\": \"/mac/control\"\r\n" +
	//		    "      }\r\n" +
	//		    "    ],\r\n" +
	//		    "    \"services\": [\r\n" +
	//		    "      {\r\n" +
	//		    "        \"service\": \"Merchant Acceptance Controls\",\r\n" +
	//		    "        \"id\": \"94dd021a-2f47-491c-86ea-cf6559638f06\",\r\n" +
	//		    "        \"status\": \"Completed\",\r\n" +
	//		    "        \"entity\": \"/merchant/card_services/mac\"\r\n" +
	//		    "      }\r\n" +
	//		    "    ],\r\n" +
	//		    "    \"id\": \"7f958f08-5da3-4437-9cff-9bb54f1fd31b\",\r\n" +
	//		    "    \"status\": \"Completed\",\r\n" +
	//		    "    \"entity\": \"/merchant\"\r\n" +
	//		    "  },\r\n" +
	//		    "  \"successful\": true\r\n" +
	//		    "}";
	//  }

	//	@Test
	//		public void test2() throws Exception {
	//			
	//			List<String> e1 = Arrays.asList( "cnp", "ecomm" );
	//		Assert.assertEquals( true, CollectionUtils.isEqualCollection( e1, Arrays.asList( "ecomm", "cnp" ) ) );
	//
	//		Assert.assertEquals( false, CollectionUtils.isEqualCollection( e1, Arrays.asList( "ecomm", "cnp", "cont_auth" ) ) );
	//		Assert.assertEquals( false, CollectionUtils.isEqualCollection( e1, Arrays.asList( "ecomm" ) ) );
	//	
	//		}

	//	@Test
	//	public void test3() throws Exception {
	//		String uri = MmpConstants.VIEW_SEVEN_DAY_SETTLEMENT_OPERATION;
	//		System.out.println( Mapper.forURI( uri ).getKlass() );
	//
	//	}

	//	@Test
	//	@Ignore
	//	public void test2() throws Exception {
	//
	//		//		System.out.println( StringInflector.from( ConfigurableEndOfDay.class ).toUnderscore() );
	//		//		System.out.println( StringInflector.from( ConfigurableEndOfDay.class ).toDotted() );
	//		//		System.out.println( StringInflector.from( ConfigurableEndOfDay.class ).toHumanReadable() );
	//		//		System.out.println( StringInflector.from( ConfigurableEndOfDay.class ).toConstant() );
	//		//		System.out.println( StringInflector.from( (String) null ).toConstant() );
	//
	//		for ( Entity entity : Entity.values() ) {
	//			Class<? extends MerchantSetup> clazz = entity.getKlass();
	//			System.out.println( clazz.getSimpleName() );
	//			for ( Operation operation : Operation.values() ) {
	//				Mapper mapper = Mapper.forClass( clazz ).forOperation( operation );
	//				try {
	//					System.out.println( "\t" + operation + ": \n\t\turl \t: " + mapper.getURL() + "\n\t\trequest : " + mapper.getRequestClass().getSimpleName() + "\n\t\tresponse: " + mapper.getResponseClass().getSimpleName() );
	//				}
	//				catch ( Exception e ) {
	//					System.out.println( "\t" + operation + ": " + e.getClass() + " : " + e.getMessage() );
	//				}
	//				catch ( Error e ) {
	//					System.out.println( "\t" + operation + ": " + e.getClass() + " : " + e.getMessage() );
	//				}
	//			}
	//
	//		}
	//		//
	//		//		Inflector<Class<Merchant>> mapper = Inflector.forClass( Merchant.class ).forOperation( Operation.ADD );
	//		//		Assert.assertEquals( "/merchant/add", mapper.getURL() );
	//		//		Assert.assertEquals( AddMerchantRequest.class, mapper.getRequestClass() );
	//		//		Assert.assertEquals( MerchantResponse.class, mapper.getResponseClass() );
	//		//
	//		//		Inflector<Class<Merchant>> deleteMerchant = Inflector.forClass( Merchant.class ).forOperation( Operation.DELETE );
	//		//		Assert.assertEquals( "/merchant/delete", deleteMerchant.getURL() );
	//		//		Assert.assertEquals( DeleteMerchantRequest.class, deleteMerchant.getRequestClass() );
	//		//		Assert.assertEquals( MerchantResponse.class, deleteMerchant.getResponseClass() );
	//		//
	//		//		Inflector<Class<Merchant>> viewMerchant = Inflector.forClass( Merchant.class ).forOperation( Operation.VIEW );
	//		//		Assert.assertEquals( "/merchant/view", viewMerchant.getURL() );
	//		//		Assert.assertEquals( ViewRequest.class, viewMerchant.getRequestClass() );
	//		//		Assert.assertEquals( ViewMerchantResponse.class, viewMerchant.getResponseClass() );
	//		//
	//		//		System.out.println( Inflector.forClass( Cv2Avs.class ).forOperation( Operation.ADD ).getRequestClass() );
	//		//		System.out.println( Inflector.forClass( Cv2Avs.class ).forOperation( Operation.VIEW ).getResponseClass() );
	//		//		
	//		//		
	//		//		System.out.println( Inflector.forClass( RedecardMid.class ).forOperation( Operation.ADD ).getRequestClass() );
	//		//
	//		//		System.out.println( Inflector.forClass( RedecardMid.class ).forOperation( Operation.ADD ).getURL() );
	//		//
	//		//
	//		//		System.out.println( Inflector.forClass( Client.class ).forOperation( Operation.EDIT ).getURL() );
	//		//		System.out.println( Inflector.forClass( Client.class ).forOperation( Operation.EDIT ).getRequestClass() );
	//		//		System.out.println( Inflector.forClass( Client.class ).forOperation( Operation.EDIT ).getResponseClass() );
	//		
	//		
	//		MyWebServiceClient webServiceClient = new MyWebServiceClient();
	//
	//		webServiceClient.add( ExampleData.createMerchant() );
	//
	//		System.out.println( webServiceClient.getFullUrl() );
	//		System.out.println( webServiceClient.getRequest() );
	//
	//		webServiceClient.add( ExampleData.createClient(), "MERCHANT-GUID" );
	//
	//		System.out.println( webServiceClient.getFullUrl() );
	//		System.out.println( webServiceClient.getRequest() );
	//
	//		webServiceClient.add( ExampleData.createMac(), "MERCHANT-GUID" );
	//
	//		System.out.println( webServiceClient.getFullUrl() );
	//		System.out.println( webServiceClient.getRequest() );
	//
	//		webServiceClient.add( new Parcelado(), "CLIENT-GUID" );
	//		//		webServiceClient.view( Merchant.class, "CLIENT-GUID" );
	//
	//		System.out.println( webServiceClient.getFullUrl() );
	//		System.out.println( webServiceClient.getRequest() );
	//	}
	//
	//	class MyWebServiceClient extends WebServiceClient {
	//
	//
	//		public <T extends MerchantSetup> MyWebServiceClient add( T merchantSetup, String parentGuid ) throws Exception {
	//			Class<? extends MerchantSetup> clazz = merchantSetup.getClass();
	//			Mapper i = Mapper.forClass( clazz ).forOperation( Operation.ADD );
	//			this.setUrl( i.getURL() );
	//			AddRequestFor<T> newInstance = (AddRequestFor<T>) i.getRequestClass().newInstance();
	//			newInstance.setObject( merchantSetup );
	//
	//			// we should use interfaces for that
	//			Method setClientGuid = ReflectionUtils.findMethod( newInstance.getClass(), "setClientGuid", String.class );
	//			if ( setClientGuid != null ) {
	//				setClientGuid.invoke( newInstance, parentGuid );
	//			}
	//
	//			Method setMerchantGuid = ReflectionUtils.findMethod( newInstance.getClass(), "setMerchantGuid", String.class );
	//			if ( setMerchantGuid != null ) {
	//				setMerchantGuid.invoke( newInstance, parentGuid );
	//			}
	//
	//			Method setMidGuid = ReflectionUtils.findMethod( newInstance.getClass(), "setMidGuid", String.class );
	//			if ( setMidGuid != null ) {
	//				setMidGuid.invoke( newInstance, parentGuid );
	//			}
	//			this.setRequest( (AuthenticatedRequest) newInstance );
	//			return this;
	//
	//		}
	//
	//		public <T extends MerchantSetup> MyWebServiceClient add( Merchant merchant ) throws Exception {
	//			return add( merchant, null );
	//		}
	//
	//	}


}
