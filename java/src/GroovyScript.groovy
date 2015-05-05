#!/usr/bin/env groovy

// install groovy :
//
// There is a conflict with on of our library  : libdatacash-xstream-java
// That could be fixed in the future but for the time being
// you can just do that  :
// sudo apt-get -y -f remove dc-contauth-update-parser
// sudo apt-get -y -f remove libdatacash-xstream-java
// sudo apt-get -y -f install  groovy


// run script :  groovy -cp /usr/share/java/libdatacash-mmp-common-java.jar  GroovyScript.groovy

import com.datacash.mmp.common.model.Merchant


print "Using normal Java objects: "
merchant = new Merchant()


merchant.with {
	id  = "GUID"
	outletName  = "Outlet Name"
}

println "Merchant id = ${merchant.id} ${merchant.outletName}"

print "Collection each: "
["one", "two", "three"].each { println it }

print "Collection filter /  transform : "
println( ["one", "two", "three"].findAll {	it.length() == 3 }.collect { it.length() }.join( ", " ))

print "Regex : "
println(["one", "two", "three"].findAll { it =~ /e/ }.join( ", " ))


print "Multi line strings: "
println """
<xml>
	long string with "
</xml>
"""


print "NullPoint prevention: "
println merchant?.clients?.get(0)?.name

print "Maps: "
map = [CA: 'California', MI: 'Michigan']
def list = [1, 4, 6, 9]
def range = 10..20
def pattern = ~/fo*/

map << [WA: 'Washington'] // add an item

assert list[1] == 4
assert map['CA'] == 'California'


map.each{ key,value -> println value }


print "Command lines"
println "ls".execute().text;


