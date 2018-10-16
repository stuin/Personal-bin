id=$1
raw=$(curl -L https://steamdb.info/app/$id | grep -o "<title>[^·]*\|<img class=[^>]*")
echo $raw

title=$(echo $raw | cut -d '<' -f2 | sed 's/title>//')
image=$(echo $raw | cut -d '<' -f3 | awk '{print $4}' | sed 's/src=\"//' | sed 's/\"//')

echo "Setting up $title"

base="[Desktop Entry]\n
Name=$title\n
Comment=Play this game on Steam\n
Exec=steam steam://rungameid/$id\n
Icon=steam_icon_$id\n
Terminal=false\n
Type=Application\n
Categories=Game;\n"

file="$HOME/.local/share/applications/$title.desktop"

echo -en $base > "$file"
chmod +x "$file"

icon="$HOME/.local/share/icons/hicolor/32x32/apps/steam_icon_$id"

curl -o "$icon.jpg" $image
convert "$icon.jpg" "$icon.png"
rm "$icon.jpg"