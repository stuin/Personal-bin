#Wait for complete startup
sleep 3

#Check intenet connection
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -eq 0 ]]; then
	echo "Online"

	#Check ssh connection
	ssh -o ConnectTimeout=10 -q datar exit
	if [[ $? -eq 0 ]]; then
		echo "Data Server Detected"
	else
		echo "Data Server not found"
		notify-send 'Lieutenant Commander Data' 'Connection lost: Check remote ip.' --icon=dialog-information
	fi
fi
