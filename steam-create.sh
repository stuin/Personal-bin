#Get data from steamdb
id=$1
raw=$(curl -L https://steamdb.info/app/$id | grep -o "<title>[^·]*\|<img class=[^>]*")

#Separate out title and image
title=$(echo $raw | cut -d '<' -f2 | sed 's/title>//')
image=$(echo $raw | cut -d '<' -f3 | awk '{print $4}' | sed 's/src=\"//' | sed 's/\"//')

echo "Setting up $title"

#Define base file paths
icon="$HOME/.local/share/icons/hicolor/32x32/apps/steam_icon_$id"
file="$HOME/.local/share/applications/$title.desktop"

#Define shortcut file contents
base="[Desktop Entry] \nName=$title \nComment=Play this game on Steam \nExec=steam steam://rungameid/$id \nIcon=steam_icon_$id \nTerminal=false \nType=Application \nCategories=Game;\n"

#Create actual shortcut
echo -en $base > "$file"
chmod +x "$file"

#download and format image
curl -o "$icon.jpg" $image
convert "$icon.jpg" "$icon.png"
rm "$icon.jpg"