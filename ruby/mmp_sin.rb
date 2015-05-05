#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
set :bind, '0.0.0.0'

require 'open-uri'
require 'sequel'
require 'json'
require 'net/http'
require 'net/https'
require 'active_support'
require 'sequel'

# sudo apt-get install ruby1.9; sudo apt-get install rubygems1.9;sudo gem1.9.1 install json --http-proxy http://proxy.win.datacash.com:8080; sudo gem1.9.1 install sequel --http-proxy http://proxy.win.datacash.com:8080;  sudo gem1.9.1 install mysql --http-proxy http://proxy.win.datacash.com:8080;  sudo gem1.9.1 install trollop --http-proxy http://proxy.win.datacash.com:8080;sudo gem1.9.1 install activesupport  --http-proxy http://proxy.win.datacash.com:8080


#################
# Configuration #

$port = 443
$timeout=30
$proxy_address = 'proxy.win.datacash.com'
$proxy_port = 8080
$db_sock = '/var/run/mysqld/mysqld-configdb.sock'
$db_port = 3326
# $db = Sequel.connect(:adapter => 'mysql', :user => 'root', :host => $address, :database => 'mcdb_mmp',:password=>'', :port=>3326, :socket=>'/var/run/mysqld/mysqld-configdb.sock')
$db = Sequel.connect(:adapter => 'mysql', :user => 'root', :host => $address, :password=>'', :port=> $db_port, :socket=>$db_sock )

# $address ='accreditation.datacash.com'
# $use_proxy=true # set to true to access the accreditation instances

$address ='localhost'
$use_proxy=false # set to true to access the accreditation instances
$mmp_ws_path="dc-mmp-webservice"
$mac_ws_path="dc-mac-config-webservice"
$login_email="testuser@example.com"
$login_password= "password"

# End of Configuration #
########################

#enable :sessions
use Rack::Session::Pool

def post_raw_json( url_path , r )

      if $use_proxy
        http = Net::HTTP.new( $address , $port , $proxy_address, $proxy_port)
      else
        http = Net::HTTP.new( $address , $port )
      end
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.read_timeout = $timeout
      json = JSON.pretty_generate(r)
      puts "Request  ( #{url_path} ) :  \n#{json}"
      app =  $mmp_ws_path
      app =  $mac_ws_path if(url_path.start_with? "/rule/")
      resp = http.post( "/#{app}/#{url_path}", json, { 'Content-Type' => "application/json" , 'username'=>'test' , 'password'=>'test'})
      puts "Response : #{resp.response.body}"
      JSON.parse(resp.response.body)
end


class Bubble
  attr_accessor :json, :url , :response, :mode


  def html
    """
      <div class='bubble'>
        </b><a href='#{self.return_url}'>#{self.mode} #{self.url}</a><b>:
        <ul>
          <li>
            Request:<pre>#{self.json}</pre>
          </li>
          <li>
            Response:<pre>#{self.response}</pre>
          </li>
        </ul>

      </div >
    """
  end

  def json_without_session
    j = JSON.parse(self.json)
    j.delete 'session_token'
    JSON.pretty_generate(j)
  end

  def return_url
    "/?url=#{CGI.escape(self.url)}&mode=#{CGI.escape(self.mode)}&json=#{CGI.escape(self.json_without_session)}"
  end
end

def conversation
  session['conversation'] = [] if session['conversation'].nil?
  session['conversation']
end


configure do
  mime_type :text, 'text/plain'
end

get '/' do
   @conversation = conversation
   @actions =  $db["select distinct operation  from  scdb_dc_mmp_webservice.scs_msp_permission"].select
   @msps =  $db["select distinct msp  from  scdb_mmp.scd_msp_acquirer_clearinghouse"].select
   @tails = {
      "mysql general-txndb" => "/var/lib/mysql/general/txndb/std_log/general-txndb.log" ,
      "mysql configdb" => "/var/lib/mysql/configdb/std_log/configdb.log" ,
      "mmp-webservice" => "/var/log/datacash/dc-mmp-webservice.log" ,
      "mmp-processor" => "/var/log/datacash/dc-mmp-processor.log" ,
      "mmp-ui" => "/var/log/datacash/dc-mmp-ui.log" ,
      "mac-ws" => "/var/log/datacash/dc-mac-webservice.log" ,
      "mac-config" => "/var/log/datacash/dc-mac-config-webservice.log" ,
      "custdb" => "/var/log/datacash/custdb.log" ,
      "DPG" => "/var/log/datacash/authd.log" ,
      "tidsetup" => "/var/log/tidsetup/tidsetup.log" ,
      "deploy" => "/var/log/tomcat6/localhost.#{Time.new.strftime('%Y-%m-%d')}.log" ,
      "regtest_logs" => "/home/mpm/vm-share/regression-tests/log/regtest_log" ,
   }

   params[:json] ="{\n}" if params[:json] == nil
    params[:json] ="{\n}" if params[:json] == nil
   
   erb :home
end


get '/tail' do
   content_type :text
   size = 250
   size  =  params[:size] if  params[:size] != nil
   return `tail #{params[:file]} -n #{size}`
end




get '/config' do
   $address = params[:host] if params[:host] != nil
   $use_proxy = "true" == params[:use_proxy] if params[:use_proxy] != nil
   $mmp_ws_path = params[:mmp_ws_path] if params[:mmp_ws_path] != nil
   $login_email = params[:login_email] if params[:login_email] != nil
   $login_password = params[:login_password] if params[:login_password] != nil
   $login_password = params[:login_password] if params[:login_password] != nil
   redirect "/"
end

get '/change_db' do
   $db_port = params[:port] if params[:port] != nil
   $db_sock = params[:sock] if params[:sock] != nil
   $db = Sequel.connect(:adapter => 'mysql', :user => 'root', :host => $address, :password=>'', :port=> $db_port, :socket=>$db_sock )
   redirect "/sql?sql="
end




get '/post' do
  session['conversation'] =  conversation
  b = Bubble.new
  b.url = params[:url]
  b.mode = params[:mode]
  begin
    json = JSON.parse(params[:json])
  rescue Exception=>e
    return "Error parsing Json request <b>#{params[:url]}</b> <pre>#{params[:json]}</pre>  <h1>#{e.message}</h1>: <br> <pre>#{e.backtrace.join('<br/>')}</pre>"
  end

  begin
    json["session_token"] = session['session_token']  if  params[:mode]  != 'mac'
    b.json =  JSON.pretty_generate(json)
  rescue Exception=>e
    return "Error injecting the session Json request <pre>#{params[:json]}</pre> <br> <pre>SESSION:#{session['session_token']}</pre>     <h1>#{e.message}</h1>: <br> <pre>#{e.backtrace.join('<br/>')}</pre>"
  end


  begin
    response  = post_raw_json(params[:url], json  )
  rescue Exception=>e
    return "Error posting the Json request <b>#{params[:url]}</b> :  <pre>#{b.json}</pre> <br>  <h1>#{e.message}</h1>: <br> <pre>#{e.backtrace.join('<br/>')}</pre>"
  end

  b.response = JSON.pretty_generate(response)
  session['conversation'] <<  b
  redirect b.return_url
end

get '/login/:msp' do
    r = post_raw_json( 'login', { msp: params[:msp], email: $login_email, password: $login_password})
    session['session_token'] = r["session_token"]
    session['msp'] = params[:msp]
    redirect "/"
end

get '/dump' do
    r = post_raw_json( "/merchants/list", { session_token:  session['session_token'] })
    b = Bubble.new
    b.json = JSON.pretty_generate({ session_token:  session['session_token'] })
    b.mode = "mmp"
    b.url = "/merchants/list"
    r["merchants"].each do |m|
      m["id"] = "<a href='/post?mode=mmp&url=%2Fmerchant%2Fview&json=%7B%0A++%22id%22%3A+%22#{m["id"]}%22%2C%0A++%22include_children%22%3A+true%0A%7D'>#{m["id"]}</a>"
    end
     b.response = JSON.pretty_generate(r)
     session['conversation'] =  conversation
     session['conversation'] <<  b
    redirect "/"
end

get '/clear' do
  session.clear
  redirect "/"
end


 get '/sql' do
   @conversation = conversation
   @error  = nil
   @sql = params[:sql]
   @databases =  $db["show databases;"].select
   @schema = {}
   @databases.each do | db_h|
    db = db_h[:Database]
    @schema[db] = []
    $db["show tables from #{db};"].select.each do |table|
      @schema[db] << table["Tables_in_#{db}".to_sym]
    end
   end
   begin
   @result =  $db[@sql].select
   $db[@sql].columns
   rescue  StandardError  => e
   @error = e.message
   end
   # if params[:table] != nil
   #   @table = $db["DESC #{params[:table]};"]
   # end
   erb :sql
end


get "/process" do
    puts "Running the processor"
    `/usr/share/bin/dc-mmp-processor.sh`
    redirect "/tail?file=/var/log/datacash/dc-mmp-processor.log&size=5000"
end

__END__

@@doc_form



@@home
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css" />
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>


<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>


<script>
function configure(key, value){
  var value = prompt(key, value);
  if(value != null){
    window.location.href = "/config?"+key+"="+value;
  }
}
</script>
<ul>
  <li>tools :
  <a href="/sql?sql=">database</a>,
  <a href="/process">process</a>,
  <a href="/mac">mac</a>,
  <a href="/clear">clear session</a>

  </li>
  <li>logs :
  <%  %>
  <% @tails.each_pair do |label, file| %>
    <a href="/tail?file=<%= file %>&size=5000"><%= label %></a>,
  <% end%>


  </li>

  <li>configure :
    <a href="#" onclick="configure('host','<%= $address %>' )">host = <%= $address %></a>
    <a href="#" onclick="configure('use_proxy','<%= $use_proxy %>' )">use_proxy = <%= $use_proxy %></a>
    <a href="#" onclick="configure('mmp_ws_path','<%= $mmp_ws_path %>' )">mmp_ws_path = <%= $mmp_ws_path %></a>
    <a href="#" onclick="configure('mac_ws_path','<%= $mac_ws_path %>' )">mac_ws_path = <%= $mac_ws_path %></a>
    <a href="#" onclick="configure('login_email','<%= $login_email %>' )">login_email = <%= $login_email %></a>
    <a href="#" onclick="configure('login_password','<%= $login_password %>' )">login_password = <%= $login_password %></a>
  </li>
  <li>login  :
  <% @msps.each do |msp|%>
    <a href="/login/<%= msp[:msp]%>"><%= msp[:msp]%></a>,
  <% end %>

  </li>
<h1>MMP (<%= session['msp'] %>) :  <%= $address %></h1>

  <li>Actions MMP :
  <a href="/dump">/merchants/list</a>
  <a href="/?url=%2Fmerchant%2Fview&json=%7B%0A++%22id%22%3A+%22258601b2-46d7-407b-ab2d-9844ad0aa71f%22%2C%0A++%22include_children%22%3A+true%0A%7D">/merchant/view</a>
  <a href="/?url=%2Fcheck_permission&json=%7B%0A++%22operation%22%3A+%22%2Fadmin%2Fuser%2Fview%22%0A%7D">/check_permission</a>
  <a href="/?url=%2Fmerchant%2Fadd&json=%7B%0A++%22merchant%22%3A+%7B%0A++++%22registered_company_number%22%3A+%22PI7745H4CK%22%2C%0A++++%22registered_company_name%22%3A+%22PI7745H4CK+<%= Time.new.to_i %>%22%2C%0A++++%22trading_as%22%3A+%22Pizza+Shack%22%2C%0A++++%22website_address%22%3A+%22http%3A%2F%2Fwww.example.com%2Fpizza_shack%22%2C%0A++++%22market_sector%22%3A+%22Hospitality%22%2C%0A++++%22merchant_category_code%22%3A+%221234%22%2C%0A++++%22anticipated_peak_transactions_per_second%22%3A+%221-10%22%0A++%7D%0A%7D">Add merchant</a>
  <a href="/?url=%2Fmerchant%2Fcard_services%2Fclient%2Fadd&json=%7B%0A++%22merchant%22%3A+%22GUID%22%2C%0A++%22client%22%3A+%7B%0A++++%22reseller_name%22%3A+%22DataCash%22%2C%0A++++%22outlet_name%22%3A+%22Pizza+Shack%22%0A++%7D%0A%7D">Add Client</a>
  <a href="/?url=%2Fmerchant%2Fcard_services%2Fmid%2Fadd&json=%7B%0A++%22client%22%3A+%22GUID%22%2C%0A++%22mid%22%3A+%7B%0A++++%22merchant_name%22%3A+%22Merchant+Name%22%2C%0A++++%22merchant_city%22%3A+%22Merchant+City%22%2C%0A++++%22merchant_state_country%22%3A+%22GBR%22%2C%0A++++%22acquirer%22%3A+%22redecard%22%2C%0A++++%22mid%22%3A+%22<%= rand(899999999)+100000000 %>%22%2C%0A++++%22clearinghouse%22%3A+%22redecard%22%2C%0A++++%22trading_currencies%22%3A+%5B%0A++++++%22BRL%22%0A++++%5D%2C%0A++++%22settling_currency%22%3A+%22BRL%22%2C%0A++++%22country%22%3A+%22GBR%22%2C%0A++++%22merchant_category_code%22%3A+%221234%22%2C%0A++++%22fulfill_limit%22%3A+%22100%22%2C%0A++++%22merchant_dba_name%22%3A+%22Merchant+DBA%22%0A++%7D%0A%7D">Add Redecard Mid</a>
  <a href="/?url=%2Fmerchant%2Fcard_services%2Fterminal%2Fadd&json=%7B%0A++%22mid%22%3A+%22GUID%22%2C%0A++%22terminal%22%3A+%7B%0A++++%22trading_currency%22%3A+%22BRL%22%2C%0A++++%22settling_currency%22%3A+%22BRL%22%2C%0A++++%22environments%22%3A+%5B%0A++++++%22ecomm%22%0A++++%5D%2C%0A++++%22card_schemes%22%3A+%5B%0A++++++%22visa%22%2C%0A++++++%22mastercard%22%0A++++%5D%0A++%7D%0A%7D">Add Terminal</a>
  <a href="/?url=%2Fmsp%2Fmac%2Fcontrols%2Flist&mode=mmp&json=%7B%0A%7D">List Msp Controls</a>
  <a href="/?url=%2Fmsp%2Fmac%2Fcontrol%2Fview&mode=mmp&json=%7B%0A++%22id%22%3A+%22cdd9dc58-62bc-52d1-cd7d-002147483645%22%0A%7D">View Msp Control id:1</a>
  <a href="/?url=%2Fmerchant%2Fmac%2Fcontrol%2F3ds_required%2Fadd&mode=mmp&json=%7B%0A++%22merchant%22%3A+%2250c4c868-3674-43d7-927a-e07a22e46b4c%22%2C%0A++%22control%22%3A+%7B%0A++++%22control_details%22%3A+%7B%0A++++++%22environment%22%3A+%5B%0A++++++++%22ecomm%22%2C%0A++++++++%22cnp%22%0A++++++%5D%2C%0A++++++%22card_scheme_ids%22%3A+%5B%0A++++++++10%0A++++++%5D%2C%0A++++++%22countries%22%3A+%5B%0A++++++++%22FRA%22%0A++++++%5D%0A++++%7D%0A++%7D%0A%7D">Add Merchant</a>
  </li>
  <li>Actions MAC :
  <a href="/?url=%2Frule%2Flist&mode=mac&json=%7B%0A++%22id%22%3A+%222%22%2C%0A++%22control_level%22%3A+%22msp%22%0A%7D">List Rules</a>,
  <a href="/?url=%2Frule%2Fview&mode=mac&json=%7B%0A++%22id%22%3A+%221%22%0A%7D">View Rule</a>,
  <a href="/?url=%2Frule%2F3ds_required%2Fadd&mode=mac&json=%7B%0A++%22target%22%3A+%7B%0A++++%22id%22%3A+%222%22%2C%0A++++%22control_level%22%3A+%22msp%22%0A++%7D%2C%0A++%22environment%22%3A+%5B%0A++++%22ecomm%22%2C%0A++++%22cnp%22%0A++%5D%2C%0A++%22card_scheme_ids%22%3A+%5B%0A++++10%0A++%5D%0A%7D">Add Rule</a>,
  <a href="/?url=%2Frule%2F3ds_required%2Fdelete&mode=mac&json=%7B%0A++%22id%22%3A+%221%22%0A%7D">Delete Rule</a>
 </ul>

<form action="post" method="get">

  <script>
  $(function() {
    <% mac_urls = [
      '/rule/3ds_required/add',
      '/rule/cv2_required/add',
      '/rule/avs_required/add',
      '/rule/scheme_block/add',
      '/rule/card_type/add',
      '/rule/dc_response/add',
      '/rule/bin_range/add',
      '/rule/eci_value/add',
      '/rule/pares_status/add',
      '/rule/transaction_type/add',
      '/rule/3ds_required/delete',
      '/rule/cv2_required/delete',
      '/rule/avs_required/delete',
      '/rule/scheme_block/delete',
      '/rule/card_type/delete',
      '/rule/dc_response/delete',
      '/rule/bin_range/delete',
      '/rule/eci_value/delete',
      '/rule/pares_status/delete',
      '/rule/transaction_type/delete',
      '/rule/list',
      '/rule/view'] %>
    var actions =   <%=  @actions.map do |a|  a[:operation]  end.concat( mac_urls ).to_json  %> ;
    $( "#url" ).autocomplete({
      source: actions
    });
  });
  </script>

  Mode :
  <input type="radio" name="mode" value="mmp" <%= "checked" if params[:mode] == 'mmp' || !params[:mode] %> > MMP
  <input type="radio" name="mode" value="mac" <%= "checked" if params[:mode] == 'mac' %>>Mac

  <br>
  Url : <input name="url" id="url" value="<%= params[:url]%>" style="width: 60%;"/>

  <br/>
  <textarea name="json" style="width: 100%; height: 150px;" ><%= params[:json] %></textarea><br/>
  <input type="submit" />
</form>





  <% @conversation.reverse.each do |b|%>
  <%= b.html %>
  <hr/>
  <% end %>



@@sql

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>


<ul>
    <li><a href="/">mmp</a></li>
</ul>


<% socks  = {
"3326,/var/run/mysqld/mysqld-configdb.sock" => "configdb",
"3324,/var/run/mysqld/mysqld-general-txndb.sock" => "general-txndb",
"3306,/var/run/mysqld/mysqld-regression-tests.sock"=> "regression-tests",
} %>
<b><%= "#{$db_sock}:#{$db_port}"%></b> : 
<% socks.each do |value,label| %>
  <a href="/change_db?port=<%= value.split(",")[0] %>&sock=<%= value.split(",")[1] %>" ><%= label%></a> 
<% end %>

<form action="sql" method="get">
  <textarea name="sql" style="width: 862px; height: 135px;" ><%= params[:sql] %></textarea>
  <input type="submit" />
</form>

<h3><%= @sql%></h3>
<% if @error != nil%>
<h3><em><%= @error%></em></h3>
<% else %>
<table border='1'>
<tr>
<% @result.columns.each do | col | %>
  <th><%= col%></th>
<% end %>
</tr>
<%  @result.each do | row | %>
<tr>
   <% @result.columns.each do | col | %>
       <td><pre><%= row[col]%></pre></td>
   <% end %>

</tr>
<% end %>
</table>

<%if params[:table] %>
<pre>
   INSERT INTO <%= params[:table] %> ( <%= @result.columns.join ", " %> )
   values( <% if(@result.count > 0) %> <%= @result.columns.map do | col |  @result.first[col].nil? ? "null" :  "\"#{@result.first[col]}\""  end.join "," %>   <% else %>   <%= @result.columns.map do | col | "\"#{col}\""  end.join ", " %><% end %> );
</pre>

<% end %>

<% end %>


<div id="schema" style="font-size:80%;">
  <ul>
<%  @schema.each do | db , tables | %>
<li> <%= db %>
  <ul>
   <% tables.each do | table | %>
       <li><a href="sql?sql=SELECT+*+FROM+<%= "#{db}.#{table}"%>;&table=<%= "#{db}.#{table}"%>"><%= db %>.<%= table%></a>
       <a href="/sql?sql=<%= "SHOW+CREATE+TABLE+#{db}.#{table}"%>;">[desc]</a>
       <a href="<%= "http://opengrok/source/search?q=%22#{table}%22&defs=&refs=&path=&hist=&type=&project=dc-load-static-config&project=dc-load-static-config-alt-authdb&project=dc-load-static-config-alt-repconfdb&project=dc-load-static-config-alt-slave&project=dc-load-static-config-configdb&project=dc-load-static-config-dpg-cpt&project=dc-load-static-config-general-txndb&project=dc-load-static-config-misdb&project=dc-load-static-config-office-misdb&project=dc-load-static-config-regression-authdb-slave&project=dc-load-static-config-regression-slave&project=dc-load-static-config-regression-tests&project=dc-load-static-config-regression-tests-repconfdb&project=dc-load-static-config-tdi1-regression-slave&project=dc-load-static-config-tdi1-regression-tests"%>">[dlsc]</a>
       <a href="<%= "http://opengrok/source/search?q=%22#{table}%22&defs=&refs=&path=&hist=&type=&project=dc-database-schema&project=dc-database-schema-authdb&project=dc-database-schema-configdb&project=dc-database-schema-dpg-cpt&project=dc-database-schema-general-txndb&project=dc-database-schema-gmh-misdb&project=dc-database-schema-misdb&project=dc-database-schema-office-misdb&project=dc-database-schema-repconfdb&project=dc-database-schema-reportdb"%>">[schema]</a>
       </li>
   <% end %>
  </ul>
</li>

<% end %>
  </ul>
</div>
