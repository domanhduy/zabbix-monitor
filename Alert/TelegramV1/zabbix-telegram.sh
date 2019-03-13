#!/bin/bash

##########################################################################
# Zabbix-Telegram envio de alerta por Telegram com graficos dos eventos
# Date: 25/10/2017
# Original script by Diego Maia - diegosmaia@yahoo.com.br Telegram - @diegosmaia
##########################################################################

MAIN_DIRECTORY="/usr/lib/zabbix/alertscripts"
# To enable the debug set here path of file, otherwise set /dev/null
DEBUG_FILE="/dev/null"

#############################################
# Argument to pass to the script and its manipulation
#############################################

USER=$1
SUBJECT=$2
DEBUG_SUBJECT=$2
TEXT=$3
DEBUG_TEXT=$3

# Check if there is only 2 argument (no test message, only subject)

if [ -z "$TEXT" ]
then
	TEXT=""
	DEBUG_TEXT=""
fi

# Get status and severity from subject

STATUS=$(echo $SUBJECT | awk '{print $1;}')
SEVERITY=$(echo $SUBJECT | awk '{print $2;}')
#STATUS=$(echo $SUBJECT | grep -o -E "(U[0-9A-F]{4}|U[0-9A-F]{3})")
SUBJECT=${SUBJECT#"$STATUS "}
SUBJECT=${SUBJECT#"$SEVERITY "}
SUBJECT="${SUBJECT//,/ }"

# Get graphid from text

GRAPHID=$(echo $TEXT | grep -o -E "(Item Graphic: \[[0-9]{7}\])|(Item Graphic: \[[0-9]{6}\])|(Item Graphic: \[[0-9]{5}\])|(Item Graphic: \[[0-9]{4}\])|(Item Graphic: \[[0-9]{3}\])")
TEXT=${TEXT%"$GRAPHID"}
MESSAGE="chat_id=${USER}&text=${TEXT}"
GRAPHID=$(echo $GRAPHID | grep -o -E "([0-9]{7})|([0-9]{6})|([0-9]{5})|([0-9]{4})|([0-9]{3})")

# Save text to send in file

ZABBIXMSG="/tmp/telegram-zabbix-message-$(date "+%Y.%m.%d-%H.%M.%S").tmp"
echo "$MESSAGE" > $ZABBIXMSG

#############################################
# Zabbix address
#############################################
ZBX_URL="http://103.xxx.xxx.xxx/zabbix"

##############################################
# Zabbix credentials to login
##############################################

USERNAME="Admin"
PASSWORD="pass"

#############################################
# Zabbix versione >= 3.4.1
# 0 for no e 1 for yes
#############################################

ZABBIXVERSION34="1"

############################################
# Bot data from Telegram
############################################

BOT_TOKEN='726730056:AAEPlM8i5f1NkAosabc'

# If the GRAPHID variable is not compliant not send the graph

case $GRAPHID in
	''|*[!0-9]*) SEND_GRAPH=0 ;;
	*) SEND_GRAPH=1 ;;
esac

#############################################
# To disable graph sending set SEND_GRAPH = 0, otherwise SEND_GRAPH = 1
# To disable message content sending set SEND_MESSAGE = 0, otherwise SEND_MESSAGE = 1
#############################################

SEND_GRAPH=1
SEND_MESSAGE=1

# If the GRAPHID variable is not compliant, not send the graph

case $GRAPHID in
    ''|*[!0-9]*) SEND_GRAPH=0 ;;
esac


##############################################
# Graph setting
##############################################

WIDTH=800
CURL="/usr/bin/curl"
COOKIE="/tmp/telegram_cookie-$(date "+%Y.%m.%d-%H.%M.%S")"
PNG_PATH="/tmp/telegram_graph-$(date "+%Y.%m.%d-%H.%M.%S").png"

############################################
# Width of graphs in time (second) Ex: 10800sec/3600sec=3h 
############################################

PERIOD=10800

###########################################
# Check if at least 2 parameters are passed to script
###########################################

if [ "$#" -lt 2 ]
then
	exit 1
fi

###########################################
# Convert STATUS and SEVERITY from text to ICON
# used https://apps.timwhitlock.info/emoji/tables/unicode to get icon 
# and https://codepoints.net/U+26A0 to get URL-quoted code
###########################################

case $STATUS in
	"PROBLEM") ICON="%E2%9A%A0";; #Warning sign
	"OK") ICON="%E2%9C%85";; #Check mark
	*) ICON="";;
esac

case $SEVERITY in
	"Not classified") ICON_SEV="%E2%9C%89";; # Envelope
	"Information") ICON_SEV="%F0%9F%98%8C";; # Relieved face
	"Warning") ICON_SEV="%F0%9F%98%9E";; # Disappointed face
	"Average") ICON_SEV="%F0%9F%98%A8";; # Fearful face
	"High") ICON_SEV="%F0%9F%98%A9";; # Weary face
	"Disaster") ICON_SEV="%F0%9F%98%B1";; # Face screeaming in fear
	*) ICON_SEV="";;
esac

############################################
# Send messages with SUBJECT and TEXT
############################################

#${CURL} -k -s -S --max-time 5 -c ${COOKIE} -b ${COOKIE} -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${USER}&text=${ICON} ${ICON_SEV} ${SUBJECT}" > $DEBUG_FILE

#if [ "$SEND_MESSAGE" -eq 1 ]
#then
#	${CURL} -k -s -S --max-time 5 -c ${COOKIE} -b ${COOKIE} --data-binary @${ZABBIXMSG} -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" >> $DEBUG_FILE
#fi

############################################
# Send graph
############################################

# If SEND_GRAPH=1 send the graph
if [ $(($SEND_GRAPH)) -eq '1' ]; then
	
	# First, login to Zabbix GUI
	# (check if there is "Sign in" in the button to login, otherwise change the web parameters here 

	${CURL} -k -s -S --max-time 5 -c ${COOKIE} -b ${COOKIE} -d "name=${USERNAME}&password=${PASSWORD}&autologin=1&enter=Sign%20in" ${ZBX_URL}"/index.php" >> $DEBUG_FILE

	# In some case is useful send personalized graph instead of graph of last data of item
	# So, put in TEXT variable a personalized GRAPHID, that here is managed differently from classic item GRAPHID
	if [ "${GRAPHID}" == "000001" ]; then
		GRAPHID="00002";
		${CURL} -k -s -S --max-time 5 -c ${COOKIE} -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
	elif [ "${GRAPHID}" == "000002" ]; then
		GRAPHID="00003";
		${CURL} -k -s -S --max-time 5 -c ${COOKIE}  -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
	elif [ "${GRAPHID}" == "000003" ]; then
		GRAPHID="00004";
		${CURL} -k -s -S --max-time 5 -c ${COOKIE}  -b ${COOKIE} -d "graphid=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart2.php" -o "${PNG_PATH}";
	else
		# If no personalized GRAPHID passed, download the image of graph of item
		if [ "${ZABBIXVERSION34}" == "1" ]; then
			${CURL} -k -s -S --max-time 5 -c ${COOKIE}  -b ${COOKIE} -d "itemids=${GRAPHID}&period=${PERIOD}&width=${WIDTH}&profileIdx=web.item.graph" ${ZBX_URL}"/chart.php" -o "${PNG_PATH}";
		else
			${CURL} -k -s -S --max-time 5 -c ${COOKIE}  -b ${COOKIE} -d "itemids=${GRAPHID}&period=${PERIOD}&width=${WIDTH}" ${ZBX_URL}"/chart.php" -o "${PNG_PATH}";
		fi
	fi
	
	# Send the image to Telegram
#	if [ "$SEND_MESSAGE" -eq 1 ]
#		then
#       			${CURL} -k -s -S --max-time 5 -c ${COOKIE} -b ${COOKIE} --data-binary @${ZABBIXMSG} -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" >> $DEBUG_FILE
#	fi

	${CURL} -k -s -S --max-time 5 -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" -F chat_id="${USER}" -F photo="@${PNG_PATH}" -F caption="${TEXT}" >> $DEBUG_FILE

fi

############################################
# DEBUG
############################################

# To verify invoked argument use this command ###########
# cat /tmp/telegram-debug.txt
# To enable the debug uncomment this line
# echo "User-Telegram=$USER | Debug subject=$DEBUG_SUBJECT | Subject=$ICON $SUBJECT | Debug Text=$DEBUG_TEXT | Message=$MESSAGE | GraphID=${GRAPHID} | Period=${PERIOD} | Width=${WIDTH}" >> $DEBUG_FILE

# To verify message sending ###########

# Sending message
# If messagge is correctly send the response of curl is similar to  {"ok":true,"result":{"message_id":xxx,"from":{"id":xxxx,"first_name":"xxx","username":"xxxx"},"chat":{"id":xxxxx,"first_name":"xxx","last_name":"xxx","username":"xxxxx","type":"private"},"date":xxxx,"text":"teste"}}
# If the response is different check the BOT_TOKEN
# ${CURL} -k -c ${COOKIE} -b ${COOKIE} -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${USER}&text=${SUBJECT}"

# API to send the image
# ${CURL} -k -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" -F chat_id="${USER}" -F photo="@${PNG_PATH}"

# To verify login process ###########
# Launch this command and check: if return nothing all is ok, otherwise there is something wrong
# after each execution delete the file /tmp/cookie
# curl -k -s -c /tmp/cookie -b /tmp/cookie -d "name=${USERNAME}&password=${PASSWORD}&autologin=1&enter=Sign%20in" http://192.168.10.24/index.php 


############################################
# Clean file used in the script execution
############################################

rm -f ${COOKIE}

rm -f ${PNG_PATH}

# Comment this line if preserve all sended message for archival purpose
rm -f ${ZABBIXMSG}

exit 0
