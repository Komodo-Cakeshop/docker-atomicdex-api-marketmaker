#!/bin/bash
source /userpass.txt
curl -s --url "http://127.0.0.1:7783" --data "{\"userpass\":\"$userpass\",\"method\":\"setprice\",\"base\":\"RICK\",\"rel\":\"MORTY\",\"volume\":\"1\",\"price\":\"3.3\", \"max\": true, \"cancel_previous\": true}" | jq
