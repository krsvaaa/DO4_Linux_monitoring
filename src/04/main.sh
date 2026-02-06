#!/bin/bash

#HTTP response codes:
# 200 - OK (успешный запрос)
# 201 - Created (ресурс создан)
# 400 - Bad Request (неверный запрос)
# 401 - Unauthorized (не авторизован)
# 403 - Forbidden (запрещено)
# 404 - Not Found (не найдено)
# 500 - Internal Server Error (внутренняя ошибка сервера)
# 501 - Not Implemented (не реализовано)
# 502 - Bad Gateway (плохой шлюз)
# 503 - Service Unavailable (сервис недоступен)

#HTTP methods:
# GET — запрос на получение ресурса
# POST — запрос на отправку данных
# PUT — запрос на обновление ресурса
# PATCH — запрос на частичное обновление ресурса
# DELETE — запрос на удаление ресурса

response_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
methods=("GET" "POST" "PUT" "PATCH" "DELETE")
agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler" "Library")
urls=("/home" "/settings" "/account" "/info" "/contacts" "/support")

for i in $(seq 1 5); do
	entries="$((RANDOM % 901 + 100))"
	day=$(date -d "$((i-1)) days" +%Y-%m-%d)

	logs=()

	for j in $(seq 1 $entries); do
	        hour=$((RANDOM % 24))
        	min=$((RANDOM % 60))
        	sec=$((RANDOM % 60))

		ts=$(date -d "$day $hour:$min:$sec" +"%Y-%m-%d %H:%M:%S")
		fulldate=$(date -d "$day $hour:$min:$sec" +"%d/%b/%Y:%H:%M:%S %z")


		ip="$(($RANDOM % 256)).$(($RANDOM % 256)).$(($RANDOM % 256)).$(($RANDOM % 256))"
		code=${response_codes[RANDOM % ${#response_codes[@]}]}
		method=${methods[RANDOM % ${#methods[@]}]}
		agent=${agents[RANDOM % ${#agents[@]}]}
		url=${urls[RANDOM % ${#urls[@]}]}

		logs+=("$ts|$ip - - [$fulldate] \"$method $url HTTP/1.1\" $code "-" \"$agent\"")

	done
	printf "%s\n" "${logs[@]}" | sort | cut -d'|' -f2- > "log_file_$i.log"

done
