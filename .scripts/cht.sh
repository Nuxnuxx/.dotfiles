#!/usr/bin/env bash


languages=$(echo "golang c cpp typescript rust javascript" | tr " " "\n")
core_utils=$(echo "find xargs sed awk" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "GIMME YOUR QUERY: " query

if echo "$languages" | grep -qs $selected;then
	curl cht.sh/$selected/$(echo "$query" | tr " " "+")
else 
	curl cht.sh/$selected~$query
fi

