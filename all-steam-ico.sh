#Ouput location
output="icons"

#Get separated app list
rawapps=$(curl https://api.steampowered.com/ISteamApps/GetAppList/v2)
IFS='}'
read -r -a apps <<< "$rawapps"

echo "Starting list"

#Loop through each
for app in "${apps[@]}"
do
	#Parse name and id
	name=$(echo $app | grep -o "name\":\"[^\"]*" | sed 's/name\":\"//')
	id=$(echo $app | grep -o "appid\":[^,]*" | sed 's/appid\"://')

	echo ""
	echo ""
	echo "Loading - $name - $id"
	
	#Get ico url from site
	imagecode=$(curl -L https://steamdb.info/app/$id | grep -o ".ico\" rel[^<]*" | sed 's/.ico\" rel=\"nofollow\">//')
	echo "Found image - $imagecode"

	#Download ico from site
	curl -o "$output/$id.ico" "https://steamcdn-a.opskins.media/steamcommunity/public/images/apps/$id/$imagecode.ico"
done