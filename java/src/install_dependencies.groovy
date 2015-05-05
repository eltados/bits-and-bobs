// install dependencies

import javax.net.ssl.HostnameVerifier
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

def nullTrustManager = [
	checkClientTrusted: { chain, authType ->  },
	checkServerTrusted: { chain, authType ->  },
	getAcceptedIssuers: { null }
]

def nullHostnameVerifier = [
	verify: { hostname, session -> true }
]

SSLContext sc = SSLContext.getInstance("SSL")
sc.init(null, [
	nullTrustManager as X509TrustManager] as TrustManager[], null)
HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory())
HttpsURLConnection.setDefaultHostnameVerifier(nullHostnameVerifier as HostnameVerifier)

class Dependency{
	String name;
	String version;
	String source;
	Dependency(json){
		name  = json.name
		version  = json.version
	}
	Dependency(){
	}

	static Dependency[] fromPkgVersion(String pkgVersion){
		String[] deps = pkgVersion.split("\n").take( pkgVersion.split("\n").size() - 2 ).drop(5);
		return deps.collect {
			Dependency d = new Dependency();
			def array = it.replaceAll("\\s+", " ").split(" ");
			d.name = array[0]
			d.version = array[1]
			return d;
		}
	}
	static Dependency[] diff( Dependency[]  original ,  Dependency[] target){
		return target.findAll{ dependency -> !original.contains(dependency) }
	}

	def debian(){
		version.matches( "(\\d|\\.|d\\d)+" )
	}


	def gitTag(){
		if( debian() ==  true){
			return "debian/${version}"
		}
		return version
	}

	def gitRepo(){
		if( source){
			return source
		}
		return "git:/home/git/"+name;
	}

	def boolean equals(other){
		return other.name == name && other.version ==version
	}

	def String toString(){
		return "${name}<${version}>"
	}

	def install(){
		def command = """dc-git-buildpackage -i ${gitRepo()} ${gitTag()} """// Create the String
		//		print "Installing ${name}\t ${version} "
		printf("Installing %-40s %-25s ", name, version)
		def proc = command.execute()
		proc.waitFor()
		if(proc.exitValue() == 0 ){
			println "[OK]"
		}else{
			println " [ERROR]"
			throw new RuntimeException( " Could not install ${name} ${version} :\n dc-git-buildpackage -i ${gitRepo()} ${gitTag()} \n" + proc.err.text );
		}
	}
}

def String openURI(url){
	if(url.startsWith( "http" )){
		return  url.toURL().text;
	}else{
		return new File(url).text
	}
}


String url = args[0]

// trigger sudo
"sudo echo \"\"".execute().getText()


// download and parse the dependency file
String jsonString = openURI(url)

println jsonString;
def json  = new groovy.json.JsonSlurper().parseText( jsonString)

// Convert the json dependencies as Dependency objects
dependencies = if(json.dependencies.size() > 0){
	dependencies = json.dependencies.collect{ new  Dependency(it) }
}

toUpgrade = [];

// If the valmorph url is specified do it
if(json && json.valmorph){
	String valmorphText  = openURI(json.valmorph)
	String currentVersionsText  = "dc-pkg-versions".execute().getText()

	// Get the packages that are different
	toUpgrade = Dependency.diff( Dependency.fromPkgVersion( currentVersionsText ), Dependency.fromPkgVersion( valmorphText ))
	// Remove the packages that are specified as dependencies
	toUpgrade = toUpgrade.findAll{  d -> !dependencies.collect{it.name}.contains(d.name)}

	// reject the non debian
	toUpgrade = toUpgrade.findAll{  d -> d.debian() }
}


toUpgrade.addAll(dependencies)

println "\n${toUpgrade.size()} packages to update : "+ toUpgrade.collect{ it.name}.join(", ") +"\n"

toUpgrade.each {  it.install() }



