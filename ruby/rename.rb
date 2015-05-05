#!/usr/bin/env ruby


require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'active_support'

class String
  def uncapitalize 
    self[0, 1].downcase + self[1..-1]
  end
end

i = 305
j = 778

fields = %w( 
   configurable_end_of_day
   transaction_reference_in_settlement
   seven_day_settlement
)


if false 

fields.each do | field|

puts """

---++ #{field.humanize}

<ul>
  <li>Request URL: <code>https://HOST/dc-mac-config-webservice/rule/#{field}/add</code></li>
  <li>Type of request: POST</li>
  <li>Content-Type: <code>application/json</code></li>
  <li>HTTP headers required:
<ul>
<li>username=<font color='red'>username</font></li>
<li>password=<font color='red'>password</font></li>
</ul>
</li>
<li>Request content:

<pre class=\"code\">{
  \"target\" : {
    \"id\" : \"<font color=\"red\">custid</font>\",
    \"control_level\" : \"merchant\"
  },
  \"environment\" : [ \"ecomm\", \"cnp\" ],
  \"card_scheme_ids\" : [ <font color=\"red\">cardschemes</font> ]
}</pre>
</li>
</ul>

   * <code>card_scheme_ids</code>: should be a comma-delimited list of integer values from the card scheme data table. e.g. <code>\"card_scheme_ids\" : [ 16, 17, 18, 11, 20, 10 ]</code>
   * <code>environment</code>: should be a comma-delimited list of environments . e.g. <code>\"environment\" : [ \"ecomm\", \"cnp\" ]</code>

"""
end
end


class APM

  def initialize(value, url )
    @value = value;
    @url = url;
  end
  
  def entity
    @value.underscore.upcase
  end 
  
  def internal_operation(prefix="add_")
    prefix+@value.underscore.downcase
  end 

  def url
    @url
  end  
  def package
    entity.downcase.gsub("_",".")
  end  

  
  def class_name
    @value
  end
end

apms =  [
  APM.new( "DnbLithuania" , "/merchant/apms/dnb/ltu"),
  APM.new( "DanskeLithuania" , "/merchant/apms/danske/ltu"),
  APM.new( "CitadeleLatvia" , "/merchant/apms/citadele/lva"),
  APM.new( "SwedbankSweden" , "/merchant/apms/swedbank/swe"),
  APM.new( "SwedbankLithuania" , "/merchant/apms/swedbank/ltu"),
  APM.new( "SwedbankLatvia" , "/merchant/apms/swedbank/lva"),
  APM.new( "SwedbankEstonia" , "/merchant/apms/swedbank/est"),
  APM.new( "SebLithuania" , "/merchant/apms/seb/ltu"),
  APM.new( "SebLatvia" , "/merchant/apms/seb/lva"),
  APM.new( "NordeaLithuania" , "/merchant/apms/nordea/ltu"),
  APM.new( "NordeaSweden" , "/merchant/apms/nordea/swe"),
  APM.new( "ShbSweden" , "/merchant/apms/shb/swe"),
]



apms.each do |apm| 
		puts " MmpConstants.VIEW_#{apm.entity}_OPERATION,"
end


apms.each do |apm| 
		puts "cases.put( \"#{apm.url}/add\", ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() ) );"
end
apms.each do |apm| 
		puts """
<xsl:template name=\"#{apm.class_name.uncapitalize}FieldsTemplate\">
			Bank Code: <xsl:value-of select=\"apm/bankCode\" />
</xsl:template>
    """
end



%w[
    dc-mmp-webservice-testing
    dc-mmp-webservice
    datacash-mmp-localisation
    libdatacash-mmp-common-java
    dc-mmp-processor-testing
    dc-load-static-config-configdb
    dc-mmp-ui-testing
    mmp-dependencies
    libdatacash-regtest-mmp-java
    dc-database-schema-configdb
    dc-mmp-ui
    dc-mmp-processor 
].each do |p|
  puts "http://git/cgi-bin/git-tools/git-diff.cgi?repository=#{p}.git&from_sha1=mmp_apm_list&to_sha1=mmp_apm_reviewed"
end


exit

[apms.first].each do |apm| 
code =  <<-eos
package com.datacash.mmp.webservice.test.service.client.apm.#{apm.package};

import junit.framework.Assert;

import org.junit.Before;
import org.junit.Test;

import com.datacash.comms.exceptions.CommsException;
import com.datacash.mmp.common.beans.request.AddAPMRequest;
import com.datacash.mmp.common.beans.response.MerchantResponse;
import com.datacash.mmp.common.model.Merchant;
import com.datacash.mmp.common.model.apm.#{apm.class_name};
import com.datacash.mmp.common.model.apm.NordeaSweden;
import com.datacash.mmp.common.model.string.json.objects.Country;
import com.datacash.mmp.common.model.string.json.objects.Currency;
import com.datacash.mmp.common.model.string.json.objects.Technology;
import com.datacash.mmp.test.asserts.CustomAssert;
import com.datacash.mmp.test.utility.Msp;
import com.datacash.mmp.test.utils.ExampleData;
import com.datacash.mmp.test.utils.MaskTools;
import com.datacash.mmp.test.utils.MmpMerchantHelper;
import com.datacash.mmp.test.utils.WebServiceClient;
import com.datacash.mmp.webservice.test.AbstractSimpleTest;
import com.datacash.resultfile.ResultFile;


public class Add#{apm.class_name}Test extends AbstractSimpleTest {

	private Merchant merchant;
	private String clientGuid;
	private WebServiceClient webServiceTester;

	@Before
	public void setup() throws Exception {

		webServiceTester = new WebServiceClient();
		String session = webServiceTester.login( Msp.WL_Swedbank_Sw ).getSessionToken();

		webServiceTester.setUrl( "#{apm.url}add" );
		webServiceTester.setRemoveEntityFieldsInRequests( true );

		merchant = MmpMerchantHelper.createMerchant( session,
		    ExampleData.createMerchant(),
		    ExampleData.createClient(),
		    ExampleData.createSwedbankNordicMid(),
		    ExampleData.createSwedbankNordicTerminal() );

		clientGuid = merchant.getClients().get( 0 ).getId();
	}


	@Test
	public void addEmptyRequest() throws Exception {
		AddAPMRequest<#{apm.class_name}> request = new AddAPMRequest<#{apm.class_name}>();

		try {
			webServiceTester.post( request ).getResponse( MerchantResponse.class );
			Assert.fail( "An exception should have been thrown" );
		}
		catch ( CommsException e ) {

			Assert.assertEquals( "When the request does not contain an APM, the webservice returns an http code of  400 ( Bad Request ) with the response {\n" +
			    "  \"successful\": false,\n" +
			    "  \"reason\": \"Invalid request\"\n" +
			    "} but this http error code gets caught in the client library and a comms exception get thrown", CommsException.class, e.getClass() );
			// see http://opengrok/source/xref/libdatacash-comms-https-java/src/com/datacash/comms/https/Client.java#169
		}

	}

	@Test
	public void testAddInvalidClientGuid() throws Exception {

		AddAPMRequest<#{apm.class_name}> request = ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() );
		request.setClientGuid( "INVALID" );
		MerchantResponse response = webServiceTester.post( request ).getResponse( MerchantResponse.class );

		CustomAssert.assertError( "Details not found", response );
	}

	@Test
	public void addSuccess() throws Exception {
		AddAPMRequest<#{apm.class_name}> request = ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() );
		request.setClientGuid( clientGuid );

		MerchantResponse response = webServiceTester.post( request ).getResponse( MerchantResponse.class );

		CustomAssert.assertSuccess( response );

		ResultFile.createAndName(
		    "URL", webServiceTester.getFullUrl(),
		    "Add #{apm.entity.humanize} request", MaskTools.mask( webServiceTester.getRequest() ),
		    "Add #{apm.entity.humanize} response", MaskTools.mask( webServiceTester.getResponse() ) );
	}


	@Test
	public void #{apm.class_name}InvalidCountry() throws Exception {
		AddAPMRequest<#{apm.class_name}> request = ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() );
		request.getApm().setCountry( Country.LVA ); // Wrong country
		request.setClientGuid( clientGuid );

		MerchantResponse response = webServiceTester.post( request ).getResponse( MerchantResponse.class );

		CustomAssert.assertError( "Request failed validation: Violations { Invalid country }", response );
	}

	@Test
	public void #{apm.class_name}InvalidCurrency() throws Exception {
		AddAPMRequest<#{apm.class_name}> request = ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() );
		request.getApm().setProcessingCurrency( new Currency( "USD" ) ); // Wrong currency
		request.setClientGuid( clientGuid );

		MerchantResponse response = webServiceTester.post( request ).getResponse( MerchantResponse.class );

		CustomAssert.assertError( "Currency not supported", response );
	}

	@Test
	public void testAddDuplicatedService() throws Exception {
		AddAPMRequest<#{apm.class_name}> request = ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() );
		request.setClientGuid( clientGuid );
		MerchantResponse response = webServiceTester.post( request ).getResponse( MerchantResponse.class );

		CustomAssert.assertSuccess( response );

		// Add the service a 2nd time 
		request = ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() );
		request.setClientGuid( clientGuid );
		response = webServiceTester.post( request ).getResponse( MerchantResponse.class );

		CustomAssert.assertError( "Requested service has already been enabled for this Client", response );
	}

	@Test
	public void invalidValues() throws Exception {
		AddAPMRequest<#{apm.class_name}> request = ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() );
		request.getApm().setCountry( null );
		request.getApm().setEmail( null );
		request.getApm().setTaxCode( null ); // TODO to be fixed
		request.setClientGuid( clientGuid );

		MerchantResponse response = webServiceTester.post( request ).getResponse( MerchantResponse.class );
		CustomAssert.assertError( "Request failed validation: Violations { Country is mandatory, Email address is mandatory, Tax code is mandatory }", response ); // TODO to be fixed
	}

	@Test
	public void invalidTypeOfAPM() throws Exception {
		AddAPMRequest<NordeaSweden> request = ExampleData.createAddAPMRequest( ExampleData.createNordeaSweden() );
		request.setClientGuid( clientGuid );

		MerchantResponse response = webServiceTester.post( request ).getResponse( MerchantResponse.class );
		CustomAssert.assertError( "Request failed validation: Violations { Invalid country, MAC key is mandatory, Merchant id is mandatory, Payment due date is mandatory, Tax code is mandatory }", response ); // TODO to be fixed
	}

	@Test
	public void invalidTechnology() throws Exception {
		AddAPMRequest<#{apm.class_name}> request = ExampleData.createAddAPMRequest( ExampleData.create#{apm.class_name}() );
		request.getApm().setDevelopmentTechnology( new Technology( "UNKNOWN" ) );
		request.setClientGuid( clientGuid );

		MerchantResponse response = webServiceTester.post( request ).getResponse( MerchantResponse.class );
		CustomAssert.assertError( "Technology is not supported", response );
	}
}
eos

# File.open("#{apm.class_name}.java", 'w') {|f| f.write(code ) }
puts code


end

exit
apms.each do |apm| 
  puts "	INSERT INTO `scs_internal_operations` (`sycouid`, `internal_operation`, `setup_method`, `webservice`) VALUES (NULL,'#{apm.internal_operation}','manual','apg');"
  puts "	INSERT INTO `scs_internal_operations` (`sycouid`, `internal_operation`, `setup_method`, `webservice`) VALUES (NULL,'#{apm.internal_operation('delete_')}','manual','apg');"
end


apms.each do |apm| 
  puts """	VIEW_#{apm.entity} (
	    \"#{apm.url}/view\",
	    MmpOperation.ADD_#{apm.entity},
	    View#{apm.class_name}Factory.class,
	    ViewAPMResponse.class),
      
      """
end
exit;

if false
apms.each do |apm| 
  puts "	#{apm.entity} (MmpOperation.ADD_#{apm.entity}, MmpOperation.DELETE_#{apm.entity}),"
end
apms.each do |apm| 
  puts "	public static final String MmpConstants.ADD_#{apm.entity}_INTERNAL_OPERATION_#{apm.entity} = \"#{apm.url}/add\";"
end
apms.each do |apm| 
  puts "	ADD_#{apm.entity} (MmpConstants.ADD_#{apm.entity}_OPERATION, MmpConstants.ADD_#{apm.entity}_INTERNAL_OPERATION\", AddAPMRequest.class, InfoMessageConstants.SERVICE_KEY_#{apm.entity}),"
end
end


i = 345
j = 846


roles = ['MSP Standard' , 'MSP Admin', 'DataCash Support' , 'DataCash Superuser']
msps  = [4, 10, 11, 12 , 13, 14, 15]


msps.each do | msp|
  apms.each do | apm|
    ["add","view", "delete"].each do | action |
      i += 1
      puts "INSERT INTO `scs_msp_permission` (`sycouid`, `id`, `msp_id`, `operation`, `rule`) VALUES (NULL,#{i},#{msp},'#{apm.url}/#{action}','allow');"
    end
  end
end


apms.each do | apm|
  roles.each do | role |
    ["add","view", "delete"].each do | action |
      j += 1
      puts "INSERT INTO `scs_permission_whitelist` (`sycouid`, `id`, `user_level`, `operation`) VALUES (NULL,#{j},'#{role}','#{apm.url}/#{action}');";
    end
  end
end


["add","view", "delete"].each do | action |
  apms.each do | apm|
      puts "INSERT INTO `scs_operations` (`sycouid`, `operation`, `display_name`) VALUES (NULL,'#{apm.url}/#{action}','merchant.card_services.#{apm.entity.downcase.gsub('_', '.')}.#{action}');";
  end
end

service="apm_nordea"
fields = %w{email
stagingNotificationUrl
liveNotificationUrl
ipAddresses
developmentTechnology
country
processingCurrency
kvv
shopId
maxAllowedRefundPercentage
secretKey }


fields.each do | field |
 puts """
	                        <tr>
	                            <td><spring:message code=\"service.#{service.gsub('_', '.')}.#{field.underscore.gsub('_', '.')}\" /></td>
	                            <td id=\"service_#{service}_#{field.underscore}\">${service.#{field}}</td>
	                        </tr>
"""
end


fields.each do | field |
 puts "service.#{service.gsub('_', '.')}.#{field.underscore.gsub('_', '.')}=#{field.underscore.gsub('_', ' ').titleize}"
end


exit;



class Luhn
  def self.checksum(number)
      
    digits = number.scan(/./).map(&:to_i)
    check = digits.pop

    sum = digits.reverse.each_slice(2).map do |x, y|
      [(x * 2).divmod(10), y || 0]
    end.flatten.inject(:+)

    (10 - sum % 10) == check
  end
end


def pan_from_bin(bin)
   pan = bin  * 1_000_000_000_0
  while( ! Luhn.checksum(pan.to_s) )
   pan += 1 
  end
  pan
end

scheme_id = { "VISA" => 10 ,  	"Mastercard" => 7}
card_type_id = { "Personal" => 1 ,  	"Corporate" => 2 , "Prepaid" => 3  }

setup = [
  { bin: 400001,  scheme: "VISA", country: "aus", card_type: "Corporate"  },
  { bin: 400002,  scheme: "VISA", country: "gbr", card_type: "Corporate"  },
  { bin: 400003,  scheme: "Mastercard", country: "aus", card_type: "Corporate"  },
  { bin: 400004,  scheme: "Mastercard", country: "gbr", card_type: "Corporate"  },
  { bin: 400005,  scheme: "VISA", country: "ita", card_type: "Corporate"  },

  { bin: 400006,  scheme: "VISA", country: "aus", card_type: "Prepaid"  },
  { bin: 400007,  scheme: "VISA", country: "gbr", card_type: "Prepaid"  },
  { bin: 400008,  scheme: "Mastercard", country: "aus", card_type: "Prepaid"  },
  { bin: 400009,  scheme: "Mastercard", country: "gbr", card_type: "Prepaid"  },
  { bin: 400010,  scheme: "VISA", country: "ita", card_type: "Prepaid"  },
  
  { bin: 400011,  scheme: "VISA", country: "aus", card_type: "Personal"  },
  { bin: 400012,  scheme: "VISA", country: "gbr", card_type: "Personal"  },
  { bin: 400013,  scheme: "Mastercard", country: "aus", card_type: "Personal"  },
  { bin: 400014,  scheme: "Mastercard", country: "gbr", card_type: "Personal"  },
  { bin: 400015,  scheme: "VISA", country: "ita", card_type: "Personal"  },
  
]

puts "\n\n"

puts " delete from shared_system_config.card_bin_info where bin  like \"4000%\";"
setup.each do |s|
  bin = s[:bin]
  scheme = s[:scheme]
  country = s[:country]
  card_type = s[:card_type]
  pan = pan_from_bin(bin)

  puts "INSERT INTO shared_system_config.card_bin_info ( bin, issuer_id, scheme_id, country, start_date, end_date, pes_id, card_type_id ) values(  \"#{bin}\",\"0\",\"#{scheme_id[scheme]}\",\"#{country}\",\"2000-01-01 00:00:00 +0000\",\"2038-08-02 11:00:00 +0100\",\"9999\",\"#{card_type_id[card_type]}\"    );"
end

puts "\n\n"

setup.each do |s|
  bin = s[:bin]
  pan = pan_from_bin(bin)
  puts "INSERT INTO `magic_card` (`cardnum`, `amount`, `auth_action`, `cv2avs_action`, `red_action`, `t3m_action`) VALUES ('#{pan}',NULL,'auth(100000)',NULL,NULL,NULL);"
end


setup.each do |s|
  bin = s[:bin]
  pan = pan_from_bin(bin)
  puts "PAN #{pan} : #{s[:scheme]}   #{s[:country]}  #{s[:card_type]}"
end



