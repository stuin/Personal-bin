Battery() {
	BATPERC=$(acpi --battery | cut -d, -f2)
	BATPERC=${BATPERC%%$'\n'*}
	BATNUM=$(("${BATPERC//%}"))
	
	if [[ $BATNUM -ge 95 ]]; then
		BATBAR="[####]"
	else 
		if [[ $BATNUM -ge 70 ]]; then
			BATBAR="[###.]"
		else
			if [[ $BATNUM -ge 45 ]]; then
				BATBAR="[##..]"
			else
				if [[ $BATNUM -ge 20 ]]; then
					BATBAR="[#...]"
				else
					BATBAR="[....]"
				fi
			fi
		fi
	fi

	if [[ $(acpi) == *"Charging"* ]]; then
		BATBAR=${BATBAR//#/>}
	fi

	echo "$BATBAR$BATPERC"
}

LemonDisplay() {
	TIME=$(date "+%A, %B %d, %Y, %T")
	BRIGHT=$(xbacklight -get)
	BAT=$(Battery)
	NAME=$(xdotool getwindowfocus getwindowname)
	DESK=$(($(xdotool get_desktop) + 1))
	
	echo "%{F#f9b234}%{B#662382}%{l}%{A:Binc:}%{A3:Bdec:} $BRIGHT $BAT %{A}%{A}%{c}%{A:Dnext:}%{A3:Dlast:} $DESK : $NAME %{A}%{A}%{r}%{A:Exit:} $TIME %{A}%{F-}%{B-}"
}

Display() {
	TIME=$(date "+%A, %B %d, %T")
	BAT=$(Battery)
	
	xsetroot -name "$BAT | $TIME"
}

if [ $# == 0 ]; then
	#Keep bar running
	while true; do
		bar-loader.sh -b
		sleep .5
	done
else
	run=true
	case $1 in
	-i)
		while $run; do
			read CODE
			DESK=$(($(xdotool get_desktop) + 1))
			case $CODE in
			Binc)
				xbacklight -inc 5
				;;
			Bdec)
				xbacklight -dec 5
				;;
			Dnext)
				if [ $DESK == 7 ]; then
					xdotool set_desktop 0
				else
					xdotool set_desktop $DESK
				fi 
				;;
			Dlast)
				if [ $DESK == 1 ]; then
					xdotool set_desktop 6
				else
					xdotool set_desktop $(($DESK - 2))
				fi 
				;;
			Exit)
				run=false
				;;
			*)
				echo "Error: no output found"
				;;
			esac
		done
		;;
	-o)
		#Run Full bar
		while true; do
			LemonDisplay
			sleep .25
		done
		;;
	-b)
		#Start bar and scripts properly
		bar-loader.sh -o | lemonbar -b -B#333333
		;;
	esac
fi


