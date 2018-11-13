#!/bin/sh
counter=0
#TODO GET tests well alone; POSt doesn't test yet and waits.


commands=$(jq . queries.json)
queries=$(jq . queries.json)
url="http://192.168.1.202/v1/opendatahub"
while true
do
echo $counter
curl -G -s $url  --data-urlencode "queries=$queries"
#curl --data-urlencode "{'commands'=[$commands, $commands]}" -X POST $url 

#curl -d '{"key1":"value1", "key2":"value2"}' -H "Content-Type: application/json" -X POST 192.168.1.202/v1/opendatahub 

counter=$((counter+1))
	
sleep 1

done
