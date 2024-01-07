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
        IP=$(echo "$entry" | grep -is "WARC-IP.*" | grep -Pose "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")
        FULL_URL=$(echo "$entry" | grep -is "WARC-.*URI.*" | grep -Pose "(?<=: ).*")
        DOMAIN=$(echo "$entry" | grep -is "WARC-.*URI.*" | grep -Pose "(?<=://)[^/]*")
        DATE=$(echo "$entry" | grep -Pose "(?<=WARC-Date: ).*") 

        res="$DATE $IP $DOMAIN $FULL_URL"
	echo -e "$res"
    done
done

# Script will extract data like this:
# 2017-12-11T01:06:35Z 104.96.221.123 www.goal.com http://www.goal.com/id-ID/people/indonesia/25833/markus-bahtiar
# 2017-12-11T01:06:35Z 104.96.221.123 www.goal.com http://www.goal.com/id-ID/people/indonesia/25833/markus-bahtiar
# 2017-12-11T00:36:24Z 165.160.15.20 www.golfsmith.com http://www.golfsmith.com/ps/search/golf-ball-retrievers?Ne=5&N=1164+4294965587+97&Ntk=All
# 2017-12-11T00:36:24Z 165.160.15.20 www.golfsmith.com http://www.golfsmith.com/ps/search/golf-ball-retrievers?Ne=5&N=1164+4294965587+97&Ntk=All
# 2017-12-11T00:02:54Z 198.41.208.117 www.gomezimages.com http://www.gomezimages.com/Portfolio/XV/i-hTg8qT8/7/f0a02a32/X4/GP2_2187-Edit-X4.jpg
# 2017-12-11T00:02:54Z 198.41.208.117 www.gomezimages.com http://www.gomezimages.com/Portfolio/XV/i-hTg8qT8/7/f0a02a32/X4/GP2_2187-Edit-X4.jpg
# 2017-12-11T00:24:48Z 103.71.236.56 www.goodcanadagoose.top http://www.goodcanadagoose.top/es/barato-ganso-de-canad%C3%A1-chilliwack-parka-hombres-en-grafito-p-102.html
# 2017-12-11T00:24:48Z 103.71.236.56 www.goodcanadagoose.top http://www.goodcanadagoose.top/es/barato-ganso-de-canad%C3%A1-chilliwack-parka-hombres-en-grafito-p-102.html
# 2017-12-11T00:15:26Z 151.101.34.62 www.gosanangelo.com http://www.gosanangelo.com/comments/reply/?target=61:150650&comment=344047
# 2017-12-11T00:15:26Z 151.101.34.62 www.gosanangelo.com http://www.gosanangelo.com/comments/reply/?target=61:150650&comment=344047

# Maybe I'll build a historic DNS service... 
