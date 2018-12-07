#Set starting location
start=0
if [ $# -eq 1 ]
then
	start=$1
fi

#Ouput location
output="icons"
missing="icons/missing"

#Get separated app list
rawapps=$(curl https://api.steampowered.com/ISteamApps/GetAppList/v2)
IFS='}'
read -r -a apps <<< "$rawapps"
len=${#apps[*]}

echo "Starting list - $(($len - $start))"

#Loop through each
for (( i = $start; i < $(($len - $start)); i++))
do
	#Parse name and id
	app=${apps[$i]}
	name=$(echo $app | grep -o "name\":\"[^\"]*" | sed 's/name\":\"//')
	id=$(echo $app | grep -o "appid\":[^,]*" | sed 's/appid\"://')

	#Displaying space and app name
	echo ""
	echo ""
	echo "Loading - $name - $id"

	#Check if file already exists
	if [ -e "$output/$id.ico" ] || [ -e "$missing/$id" ]
	then
		echo "Skipped"
	else
		#Get ico url from site
		imagecode=$(curl -L https://steamdb.info/app/$id | grep -o ".ico\" rel[^<]*" | sed 's/.ico\" rel=\"nofollow\">//')

		#Check if ico exists
		if [ ! -z "$imagecode" ]
		then
			#Download ico from site
			echo "Found image - $imagecode"
			curl -o "$output/$id.ico" "https://steamcdn-a.opskins.media/steamcommunity/public/images/apps/$id/$imagecode.ico"
		else
			echo "Image not found" >> "$missing/$id"
		fi
	fi
done