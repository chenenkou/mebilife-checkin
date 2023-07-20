#!/bin/bash

url="https://high.scay.net/user/checkin"

data='{}' 

header="Content-Type: application/json"
header="$header""\n""User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.82"

curl -X POST -H "$header" -d "$data" "$url"
