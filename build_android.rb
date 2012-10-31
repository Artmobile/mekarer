require 'rubygems'
require 'json'

bp="c2l4cGVucw==".unpack("m")[0]

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
puts "Forcing changes to github. "
`cd #{appPath}`
`git add .`
`git commit -m "auto commit as part of script"`
`git push origin master`
puts "Done";
puts
puts
def rebuild() 

	##Request Phonegap data
	puts "Requesting Project Data.";

	blob=JSON.parse(`curl -s -u #{$creds} #{$APIcall}`)

	ttl = blob['title']
	package = blob['package']
	
	##Request Rebuild
	print "Requesting Rebuild. "
	request=`curl -s -u #{$creds} -X PUT -d 'data={"pull":"true"}' #{$APIcall}`
	puts "Done."
	donecheck=""

	print "Rebuilding: [-"

	until JSON.parse(`curl -s -u #{$creds}  #{$APIcall}`)['status']['android'] == "complete"
		print "-"
	end	

	puts "]"
	puts "Done."
	puts
	puts

	puts "Now downloading"
	`curl -L -u #{$creds} -o #{ttl}-debug.apk #{$FILEPATH}/#{$project}/download/android`

	print "Removing previos installation. "
	`adb uninstall #{package}`
	puts "Done."
	puts "Installing the APK package. "
	`adb install -r #{ttl}-debug.apk`
	puts "Done."
end

Dir.chdir("#{projectPath}") do 
	rebuild()
end