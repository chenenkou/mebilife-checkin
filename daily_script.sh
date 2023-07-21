#!/bin/bash

if [ -f .env ]; then
  source .env
fi

cookie="${COOKIE}"
key="${PUSH_KEY}"

url="https://high.scay.net/user/checkin"

data="{}" 

header="Content-Type: application/json"
header="$header""\n""charset: UTF-8"
header="$header""\n""User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.82"

response=$(curl -X POST -H "$header" -b "$cookie" -d "$data" "$url")
echo $response

text=$(echo "$response" | grep -Eo '"msg":"[^"]*"')
text=$(echo "$text" | grep -oE '"msg":"[^"]+"' | sed 's/"msg":"\([^"]*\)"/\1/g')
#text=${text//\"/}
#text="${text// /%20}"
text="$text - Mebilife-checkin"
# 将字符串进行URL编码
text=$(printf "%s" "$text" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
echo $text

url="https://api2.pushdeer.com/message/push?pushkey=${key}&text=${text}"
curl -X GET "$url"
