#Check intenet connection
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -eq 0 ]]; then
	echo "Online"

	#Get ip address
	ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
	echo "IP = $ip"
	
	#Check saved ip address
	file="/home/stuin/ex-ip.txt"
	saved=$(cat $file)
	if [ "$ip" == "$saved" ]; then
		echo "Matching file found"
	else
		echo "IP not matched"

		echo $ip > $file
		rclone copy $file DropBox:
	fi
fi
