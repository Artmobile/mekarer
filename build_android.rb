require 'rubygems'
require 'highline/import'
require 'json'
require 'base64'

project="232937"

username="artmobile@gmail.com"
appPath="d:\\git_wa\\mekarer\\" 
projectPath="d:\\git_wa\\mekarer\\apk" 

APIPATH="https://build.phonegap.com/api/v1/apps";
FILEPATH="https://build.phonegap.com/apps/";

def get_password(prompt="Enter Password")
   ask(prompt) {|q| q.echo = false}
end

bp="c2l4cGVucw==".unpack("m")[0] #get_password("Enter PhoneGap Build password")

APIcall="#{APIPATH}/#{project}"
creds="#{username}:#{bp}";

##commit changes
puts "Forcing changes to github";
`cd #{appPath}`
`git add .`
`git commit -m "auto commit as part of script"`
`git push origin master`
puts "Done";

`cd #{projectPath}`

##Request Phonegap data
puts "Requesting Project Data.";

blob=`curl -s -u #{creds} #{APIcall}`
title = blob['title']
package = blob['package']

##Request Rebuild
puts "Requesting Rebuild."
request=`curl -s -u #{creds} -X PUT -d 'data={"pull":"true"}' #{APIcall}`
puts "Done. "
donecheck=""

print "[/]"

until JSON.parse(`curl -s -u #{creds}  #{APIcall}`)['status']['android'] == "complete"
	print "."
end	

puts
puts "Done. Now downloading."

download=`curl -L -s -u #{creds} -o #{title}-debug.apk #{FILEPATH}/#{project}/download/android`

`adb uninstall #{package}`
`adb install -r ./#{title}-debug.apk`