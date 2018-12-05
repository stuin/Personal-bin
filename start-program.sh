term="lxterminal -e"

hex() {
	#Random hex values with some selected
	while true; 
	do 
		head -c200 /dev/urandom | od -An -w50 -x | grep -E --color "([[:alpha:]][[:digit:]]){2}"; 
		sleep .$[RANDOM % 10]; 
	done
}

log() {
	#Display random log files
	if [ "$EUID" -ne 0 ]
	then
		echo "Please run as root to be hackerish."
		exit
	fi
	
	# turn off globbing
	set -f
	# split on newlines only for for loops
	IFS='
	'
	for log in $(find /var/log -type f); do
	# only use the log if it's a text file; we _will_ encounter some archived logs
	if [ `file $log | grep -e text | wc -l` -ne 0 ]
		then
			echo $log
			for line in $(cat $log); do
				echo $line
				# sleep for a random duration between 0 and 1/4 seconds to indicate hard hackerish work
				bc -l <<< $(bc <<< "$RANDOM % 10")" / 40" | xargs sleep
			done
		fi
	done
}

progress() {
	#Show progress bar of some length
	echo -ne "[..........]\r"	
	sleep .2
	echo -ne "[#.........]\r"
	sleep .2
	echo -ne "[##........]\r"
	sleep .2
	echo -ne "[###.......]\r"
	sleep .2
	echo -ne "[####......]\r"
	sleep .2
	echo -ne "[#####.....]\r"
	sleep .2
	echo -ne "[######....]\r"
	sleep .2
	echo -ne "[#######...]\r"
	sleep .2
	echo -ne "[########..]\r"
	sleep .2
	echo -ne "[#########.]\r"
	sleep .2
	echo  "[##########]"
}

if [ $# == 0 ]
then
	#Enter start code
	sudo echo "Accepted"
	sleep .4

	#Run Full script
	echo "Establishing connection:"
	progress
	echo "Connected."
	sleep 1
	
	echo "Starting key check:"
	$term start-program.sh -h & hexid=$!
	sleep 5

	echo "Possible keys found. Continuing process."
	sleep 2

	echo "Accessing:"
	progress
	echo "Access Granted."
	sleep 1

	echo "Checking processes."
	$term htop & hid=$!
	sleep 3
	
	echo "Activating main system."
	sudo $term start-program.sh -l & logid=$!
	sleep 5

	echo "System fully syncronized. Matrix reached."
	$term cmatrix & matrixid=$!
	sleep 3
	
	echo "Processes linked. Press enter to clear"
	read code

	printf "\u001B[31m"

	echo "Exiting..."
	sleep .5

	kill $matrixid
	echo "Matrix connection lost."
	sleep 2

	kill $logid
	sleep 1

	kill $hid
	echo "Clearing process log."
	sleep 3

	kill $hexid
	echo "Key files cleared."
	sleep 2

	echo "Program complete."
	printf "\u001B[0m"
else
	case $1 in
	-h)
		printf "\u001B[0m"
		hex
		;;
	-l)
		printf "\u001B[32m"
		log
		;;
	-p)
		progress
		;;
	-w)
		#Show recursive windows folders
		ll -R /mnt/windows
		;;
	-d)
		#Download log files
		while true;
		do
			echo "Downloading log file " + $[RANDOM]
		done
		;;
	*)
		echo "Error: no file found"
		;;
	esac
fi


