#!/bin/bash
#Skript lässt Haustelefon über die Klingelton-Test-Funktion 10 Sekunden klingeln
 
_BOXURL="http://fritz.box"
_USERNAME=""
_PASSWORD="secret"
_REQUESTPAGE="/fon_devices/edit_dect_ring_tone.lua"
_CHALLENGE=$(curl -s ${_BOXURL} | grep challenge | awk -F '"' '{print $6}') #Änderung von $4 auf $6 nach Firmware Update 06.05.17
_MD5=$(echo -n ${_CHALLENGE}"-"${_PASSWORD} | iconv -f ISO8859-1 -t UTF-16LE | md5sum -b | awk '{print substr($0,1,32)}')
_RESPONSE="${_CHALLENGE}-${_MD5}"
_SID=$(curl -i -s -k -d "response=${_RESPONSE}&username=${_USERNAME}" "${_BOXURL}" | grep -Po -m 1 '(?<=sid=)[a-f\d]+')
_SID=$(echo $_SID | awk '{print $1}') #eingefügt 06.05.17, wegen Firmware-Update hat sich etwas an Seite geändert, geht jetzt wieder
curl "${_BOXURL}${_REQUESTPAGE}?sid=${_SID}&idx=1&start_ringtest=1&ringtone=5"
curl "${_BOXURL}${_REQUESTPAGE}?sid=${_SID}&idx=1&start_ringtest=2"
sleep 10
curl "${_BOXURL}${_REQUESTPAGE}?sid=${_SID}&idx=1&stop_ringtest=1"
