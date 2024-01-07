#!/bin/bash

# Simple bash script to grep through downloaded WARC archives
# zgrep works as well but I got a better overall success rate using
# the combo below

for filename in ./*.warc.gz; do 
    echo "$filename"    
    # grep -a == --binary-files=text
    entries=$(gunzip -c -q -k $filename | dos2unix -f | grep "WARC-IP" -is -A 1 -B 10)

    prep_ent=$(echo -n "$entries" | awk 'BEGIN {RS="--\n"} {print $0"‡"}') 
    mapfile -d '‡' parts <<< "$prep_ent"
    
    for entry in "${parts[@]}"; do 
        #echo "Processing:"
	      #echo "$entry" 
        
        IP=$(echo "$entry" | grep -is "WARC-IP.*" | grep -Pose "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")
        FULL_URL=$(echo "$entry" | grep -is "WARC-.*URI.*" | grep -Pose "(?<=: ).*")
        DOMAIN=$(echo "$entry" | grep -is "WARC-.*URI.*" | grep -Pose "(?<=://)[^/]*")
        DATE=$(echo "$entry" | grep -Pose "(?<=WARC-Date: ).*") 

        res="$DATE $IP $DOMAIN $FULL_URL"
	echo -e "$res"
    done
done

