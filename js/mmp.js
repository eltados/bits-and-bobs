// ==UserScript==
// @name        mmp
// @namespace   mmp
// @include     */dc-mmp-ui/*
// @version     1.0.1
// @grant       none
// @downloadURL http://git.win.datacash.com/cgi-bin/gitweb.cgi?p=user-scripts.git;a=blob_plain;hb=master;f=mpm/greasemonkey/mmp.js
// @require     http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js
// @require     https://raw.githubusercontent.com/jeresig/jquery.hotkeys/master/jquery.hotkeys.js
// ==/UserScript==


function loginAndRefresh(){
  var msp = prompt("Login as :", "wl_swedbank_sw");
  $.post( "/dc-mmp-ui/login", { msp: msp, email: "testuser@example.com", password: "password" }).done(function() {
    window.location.href=window.location.href;
  });
}

function populate(){
  path = window.location.pathname.replace("//", "/");;
  
  switch (path){
    case "/dc-mmp-ui/login": 
      var msp = prompt("Login as :", "wl_swedbank_sw");
      $("#acquirer").val(msp);
      $("#username").val("testuser@example.com");
      $("#password").val("password");
      $("#loginSection").submit();
      break; 
    case "/dc-mmp-ui/merchant/view": 
      window.location.href = $("#action-new-client").attr("href");
      break;
    case "/dc-mmp-ui/merchant/card_services/client/view": 
      window.location.href = $("#action-new-mid").attr("href");
      break;
    case "/dc-mmp-ui/merchant/card_services/mid/view": 
      window.location.href = $("#action-new-terminal").attr("href");
      break;
    case "/dc-mmp-ui/merchant/card_services/terminal/view": 
      window.location.href = $("#breadcrumbItem2").attr("href");
      break;
    case "/dc-mmp-ui/merchants/list": 
      window.location.href=$("#action-new").attr("href");
      break;
   case "/dc-mmp-ui/merchant/card_services/mid/add": 
      window.location.href=$("#acquirer option:nth-child(3)").val();
      break; 
    case "/dc-mmp-ui/merchant/add": 
      $("#registeredCompanyName").val("Merchant " + new Date().getTime());
      $("#registeredCompanyNumber").val("21321231");
      $("#tradingAs").val("MMP co");
      $("#websiteAddress").val("http://www.mmp.com");
      $("#categoryCode").val("1234");
      $("#marketSector").val("Gaming");
      $("#peakTransaction").val("1-10");
      break; 
    case "/dc-mmp-ui/quick-start/merchant/add": 
      $("#registeredCompanyName").val("Merchant " + new Date().getTime());
      $("#registeredCompanyNumber").val("21321231");
      $("#tradingAs").val("MMP co");
      $("#websiteAddress").val("http://www.mmp.com");
      $("#categoryCode").val("1234");
      $("#marketSector").val("Gaming");
      $("#peakTransaction").val("1-10");
      $("#outletName").val("Client " + new Date().getTime());
      break; 
    case "/dc-mmp-ui/quick-start/merchant/card_services/client/add": 
     $("input[name=addservices]").click();
      break;
   case "/dc-mmp-ui/quick-start/merchant/card_services/mid/add": 
      window.location.href=$("#acquirer option:nth-child(3)").val();
      break;
    case "/dc-mmp-ui/quick-start/merchant/card_services/mid/list": 
      $("input:nth-child(1)").click();
      break;
    case "/dc-mmp-ui/merchant/card_services/client/add": 
      $("#outletName").val("Client " + new Date().getTime());
      $("#resellerName").val("Gaming co");
      $("#velocity").val("20");
      break; 
    case "/dc-mmp-ui/merchant/card_services/mid/redecard/add": 
      $("#mid").val( Math.floor(Math.random() * 899999999)+100000000 );
      $("#country").val("FRA");
      $("#merchantCategoryCode").val("1234");
      $("#tradingCurrencies").val("BRL");
      $("#settlingCurrency").val("BRL");
      $("#merchantName").val("Merchant name");
      $("#merchantCity").val("Rio");
      $("#merchantStateCountry").val("BRL");
      break;
    case "/dc-mmp-ui/merchant/card_services/mid/swedbank/add": 
      $("#mid").val( Math.floor(Math.random() * 899999999)+100000000 );
      $("#country").val("FRA");
      $("#merchantCategoryCode").val("1234");
      $("#tradingCurrencies").val("EUR");
      $("#settlingCurrency").val("EUR");
      $("#merchantName").val("Merchant name");
      $("#merchantCity").val("Rio");
      $("#merchantStreetAddress").val("1 Grand Street");
      $("#merchantPostcode").val("EH11LY");
      break; 
   case "/dc-mmp-ui/quick-start/merchant/card_services/mid/swedbank/add": 
      $("#mid").val( Math.floor(Math.random() * 899999999)+100000000 );
      $("#country").val("FRA");
      $("#merchantCategoryCode").val("1234");
      $("#tradingCurrencies").val("EUR");
      $("#settlingCurrency").val("EUR");
      $("#merchantName").val("Merchant name");
      $("#merchantCity").val("Rio");
      $("#merchantStreetAddress").val("1 Grand Street");
      $("#merchantPostcode").val("EH11LY");
      break;
    case "/dc-mmp-ui/merchant/card_services/fraud/bank_all_in_one/add": 
      $("#merchantName").val( "Merchant name");
      $("#industryType").val("retail");
      $("#mainContactName").val("Robert Smith");
      $("#mainContactEmail").val("robert.smith@gmail.com");
      $("#acquirerCustomerSupportEmail").val("customer@gmail.com");
      $("#acquirerCustomerSupportPhone").val("44505523255");
      $("#screeningModels").val("pre_authorization");
      $("#statusesAllowed").val("ok");
      $("#display").val("id");
      break;
    case "/dc-mmp-ui/merchant/card_services/terminal/generic/add": 
      $("#environments").val("ecomm");
      $("#cardSchemes").val("visa");
      break;
    case "/dc-mmp-ui/merchant/card_services/terminal/swedbank/add": 
      $("#environments").val("ecomm");
      $("#cardSchemes").val("visa");
      $("#terminalPostCode").val("EH45LU");
      break; 
    case "/dc-mmp-ui/merchant/apms/nordea/swe/add": 
      $("#email").val("me@datacash.com");
      $("#stagingNotificationUrl").val("https://staging.merchant.com");
      $("#liveNotificationUrl").val("https://live.merchant.com");
      $("#ipAddresses").val("10.80.74.51,10.80.1.230");
      $("#developmentTechnology").val("java");
      $("#country").val("SWE");
      $("#processingCurrency").val("EUR");
      $("#kvv").val("EAB6567298EAB6567298EAB6567298");
      $("#shopId").val("12344");
      $("#maxAllowedRefundPercentage").val("100");
      $("#secretKey").val("KEYA1234567QWERTY");
      break;
    case "/dc-mmp-ui/merchants/list": 
      $("#environments").val("ecomm");
      $("#cardSchemes").val("visa");
      break;
    default:
      alert( "no default values for  "+ window.location.pathname);
  }
    $(':submit').focus();
}


     
$(document).bind('keydown', 'p', function(e) {
    e.preventDefault();
    populate();
    return false;
});

$(document).bind('keydown', 'l', function(e) {
    e.preventDefault(); 
    loginAndRefresh();
    return false;
});




