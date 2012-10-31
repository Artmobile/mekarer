require 'rubygems'
require 'highline/import' # gem install highline, needed for get_password
require 'json'
require 'base64'

bp="c2l4cGVucw==".unpack("m")[0] #get_password("Enter PhoneGap Build password")

$project="232937"
$username="artmobile@gmail.com"
$APIPATH="https://build.phonegap.com/api/v1/apps"
$FILEPATH="https://build.phonegap.com/apps/"
$APIcall="#{$APIPATH}/#{$project}"
$creds="#{$username}:#{bp}"

appPath="d:\\git_wa\\mekarer\\" 
projectPath="d:\\git_wa\\mekarer\\apk" 

def get_password(prompt="Enter Password")
   ask(prompt) {|q| q.echo = false}
end

##commit changes
puts "Forcing changes to github";
`cd #{appPath}`
`git add .`
`git commit -m "auto commit as part of script"`
`git push origin master`
puts "Done";

def rebuild() 

	##Request Phonegap data
	puts "Requesting Project Data.";

	blob=JSON.parse(`curl -s -u #{$creds} #{$APIcall}`)

	ttl = blob['title']
	package = blob['package']
	
	puts ttl
	puts package

	##Request Rebuild
	puts "Requesting Rebuild."
	request=`curl -s -u #{$creds} -X PUT -d 'data={"pull":"true"}' #{$APIcall}`
	puts "Done. "
	donecheck=""

	print "Rebuilding: [-"

	until JSON.parse(`curl -s -u #{$creds}  #{$APIcall}`)['status']['android'] == "complete"
		print "-"
	end	

	puts "]"
	puts "Done. Now downloading."

	download=`curl -L -s -u #{$creds} -o #{ttl}-debug.apk #{$FILEPATH}/#{$project}/download/android`

	`adb uninstall #{package}`
	`adb install -r #{ttl}-debug.apk`
end

Dir.chdir("#{projectPath}") do 
	rebuild()
end