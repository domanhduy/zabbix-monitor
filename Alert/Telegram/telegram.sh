#!/bin/sh

CHAT_ID=`echo "$1" | cut -d " " -f 1`
TOKEN=`echo "$1" | cut -d " " -f 2`
SUBJECT="$2"
MESSAGE="$3"

NL="
"

curl --silent -X POST --retry 5 --retry-delay 0 --retry-max-time 60 --data-urlencode "chat_id=${CHAT_ID}" --data-urlencode "text=Subject: ${SUBJECT}${NL}${NL}${MESSAGE}" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true" | grep -q '"ok":true'