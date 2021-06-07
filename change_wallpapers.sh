#!/usr/bin/bash

SLEEPTIME=900
MIM_WIDTH="1366"
MIM_HEIGHT="768"

LOCALTION=/home/luiz/Imagens/Wallpapers/

# eval "$(xprop -root -notype _NET_NUMBER_OF_DESKTOPS | tr -d ' ')"

while true; do
    WALLPAPERS=("${LOCALTION}"*)
    index=$((RANDOM % ${#WALLPAPERS[@]}))
    SELECTED=${WALLPAPERS[index]}

    SIZES="$(mediainfo "${SELECTED}" | grep 'Width\|Height' | tr -d 'Height\|pixels\|Width\|:\| ')"
    declare "WIDTH""=""$(let d=$(echo ${SIZES} | awk '{print $1 }')+0;echo "${d}";)"
    declare "HEIGHT""=""$(let d=$(echo ${SIZES} | awk '{print $2 }')+0;echo "${d}";)"
    
    if [[ "${WIDTH}" -ge "${MIM_WIDTH}" ]] && [[ "${HEIGHT}" -ge "${MIM_HEIGHT}" ]]; then
        echo "CURRENT: $(basename "${SELECTED}")"
        echo "${WIDTH}x${HEIGHT}"
        dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
        var Desktops = desktops();
        for (i=0;i<Desktops.length;i++) {
                d = Desktops[i];
                d.wallpaperPlugin = "org.kde.image";
                d.currentConfigGroup = Array("Wallpaper",
                                            "org.kde.image",
                                            "General");
                d.writeConfig("Image", "file:/'"${SELECTED}"'");
        }'

    fi
    sleep ${SLEEPTIME}
    exit 0
done
