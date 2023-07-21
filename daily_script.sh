#!/bin/bash

if [ -f .env ]; then
  source .env
fi

cookie="${COOKIE}"
key="${PUSH_KEY}"

# 发送签到请求
url="https://high.scay.net/user/checkin"
data="{}"
header="Content-Type: application/json"
header="$header""\n""charset: UTF-8"
header="$header""\n""User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.82"
response=$(curl -X POST -H "$header" -b "$cookie" -d "$data" "$url")
echo $response

if [ -n "$variable" ]; then
  echo "签到请求正常"
else
  echo "签到请求异常"
  response='{"msg":"签到请求异常"}'
fi

# 将签到结果发送到aircode进行转义
aircode_url="https://ddtcr9nuii.hk.aircode.run/transfer"
response=$(curl -X POST -H "Content-Type: application/json" -d $response $aircode_url)
echo $response

# 获取签到结果中的msg字段
text=$(echo "$response" | grep -oE '"msg":"[^"]+"' | sed 's/"msg":"\([^"]*\)"/\1/g')

# 将签到结果拼接处理一下
text="米白云：$text"

# 将字符串进行URL编码
text=$(printf "%s" "$text" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')

# 发送推送请求
url="https://api2.pushdeer.com/message/push?pushkey=${key}&text=${text}"
curl -X GET "$url"
