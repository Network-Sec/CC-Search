# CC-Search
`cc_search.py`  

Simple Common Crawl Web Archive search tool - intended to keep it simple and flexible: Do it in code == do it fast and precise.

`If you want to search for passwords etc. you need to download the WARC files called CC-MAIN-20230922134342-20230922164342-00253.warc.gz` - this tool is `not` made for that, it's for finding historic info on specific domains / IP addresses. There is no tool that can search in any other way online, Common Crawl provides only this way of searching (which I think is the root of the whole problem, that why people download all the WARC files completely). 

I provided two more scripts to serialize download of WARC archives and to grep out data from those. Rest of this documentation is for the live-search python script. 

## What this does - and does not
The key to understand the tool are the `indices` of Common Crawl. They are like a library index and provide only a very limited overview of the available data - they are actually the indices of the indices. It's safest to search for `domains`, cause that's the intended `usecase`. You can of course search for other things but may stumble over the stubborn server side API that will try to interpret your request as domain.  

## I don't care about... How do I use this correctly?
TL;DR: Use this for a quick `OSINT` gig. Enter a correct domain (IP may or may not work). Don't fool around with it, only search for what you need and then lean back, be `ZEN`. I can't pronounce this enough, `ZEN` is the way of the search!

Correct usage example, this takes some time and a fresh source IP (your IP). 
```bash
$ cc_domain_search.py "tesla.com" --year 2023
https://index.commoncrawl.org/CC-MAIN-2023-50-index?url=tesla.com&output=json
504  <== Rate limit block, search again later may or may not work
https://index.commoncrawl.org/CC-MAIN-2023-40-index?url=tesla.com&output=json
504
https://index.commoncrawl.org/CC-MAIN-2023-23-index?url=tesla.com&output=json
504
https://index.commoncrawl.org/CC-MAIN-2023-14-index?url=tesla.com&output=json
200
https://index.commoncrawl.org/CC-MAIN-2023-06-index?url=tesla.com&output=json
200
curl -H 'Range: bytes=1172358122-1172490778' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-14/segments/1679296943695.23/warc/CC-MAIN-20230321095704-20230321125704-00547.warc.gz' --output test.gz
WARC-IP-Address: 23.219.222.217
WARC-Target-URI: https://www.tesla.com
curl -H 'Range: bytes=1144620389-1144753039' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-14/segments/1679296943695.23/warc/CC-MAIN-20230321095704-20230321125704-00044.warc.gz' --output test.gz
WARC-IP-Address: 23.218.146.104
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=1081146885-1081279532' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-14/segments/1679296945182.12/warc/CC-MAIN-20230323163125-20230323193125-00547.warc.gz' --output test.gz
WARC-IP-Address: 23.210.240.78
WARC-Target-URI: https://www.tesla.com
curl -H 'Range: bytes=1124290578-1124423240' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-14/segments/1679296945183.40/warc/CC-MAIN-20230323194025-20230323224025-00044.warc.gz' --output test.gz
WARC-IP-Address: 23.220.132.93
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=2748060-2748584' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-14/segments/1679296945288.47/crawldiagnostics/CC-MAIN-20230324180032-20230324210032-00674.warc.gz' --output test.gz
WARC-IP-Address: 23.223.252.49
WARC-Target-URI: http://www.tesla.com
curl -H 'Range: bytes=1138387183-1138519838' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-14/segments/1679296945288.47/warc/CC-MAIN-20230324180032-20230324210032-00044.warc.gz' --output test.gz
WARC-IP-Address: 23.223.252.49
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=1138093925-1138226583' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-14/segments/1679296945440.67/warc/CC-MAIN-20230326075911-20230326105911-00044.warc.gz' --output test.gz
WARC-IP-Address: 23.220.132.93
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=520955-521478' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764495001.99/robotstxt/CC-MAIN-20230127164242-20230127194242-00114.warc.gz' --output test.gz
WARC-IP-Address: 184.24.156.156
WARC-Target-URI: http://www.tesla.com
curl -H 'Range: bytes=979449549-979581158' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764495001.99/warc/CC-MAIN-20230127164242-20230127194242-00844.warc.gz' --output test.gz
WARC-IP-Address: 184.24.156.156
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=994732413-994864028' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764499524.28/warc/CC-MAIN-20230128054815-20230128084815-00844.warc.gz' --output test.gz
WARC-IP-Address: 23.210.0.72
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=1012362809-1012494475' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764500017.27/warc/CC-MAIN-20230202101933-20230202131933-00467.warc.gz' --output test.gz
WARC-IP-Address: 23.220.132.93
WARC-Target-URI: https://www.tesla.com
curl -H 'Range: bytes=639387825-639519492' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764500017.27/warc/CC-MAIN-20230202101933-20230202131933-00467.warc.gz' --output test.gz
WARC-IP-Address: 23.220.132.93
WARC-Target-URI: https://www.Tesla.com
curl -H 'Range: bytes=1034790208-1034921864' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764500017.27/warc/CC-MAIN-20230202101933-20230202131933-00844.warc.gz' --output test.gz
WARC-IP-Address: 23.220.132.93
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=1033100069-1033231787' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764500044.16/warc/CC-MAIN-20230203055519-20230203085519-00844.warc.gz' --output test.gz
WARC-IP-Address: 184.50.204.49
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=1024505070-1024636768' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764500151.93/warc/CC-MAIN-20230204173912-20230204203912-00844.warc.gz' --output test.gz
WARC-IP-Address: 23.197.108.191
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=1041321975-1041453628' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764500250.51/warc/CC-MAIN-20230205063441-20230205093441-00844.warc.gz' --output test.gz
WARC-IP-Address: 23.223.252.49
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=1027684446-1027816136' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764501066.53/warc/CC-MAIN-20230209014102-20230209044102-00844.warc.gz' --output test.gz
WARC-IP-Address: 23.208.32.145
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=17739624-17740176' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764501407.6/crawldiagnostics/CC-MAIN-20230209045525-20230209075525-00538.warc.gz' --output test.gz
WARC-IP-Address: 23.9.66.10
WARC-Target-URI: https://tesla.com
curl -H 'Range: bytes=1019506179-1019637821' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764501407.6/warc/CC-MAIN-20230209045525-20230209075525-00844.warc.gz' --output test.gz
WARC-IP-Address: 23.210.0.72
WARC-Target-URI: https://www.tesla.com/
curl -H 'Range: bytes=1021059586-1021191283' 'https://data.commoncrawl.org/crawl-data/CC-MAIN-2023-06/segments/1674764501555.34/warc/CC-MAIN-20230209081052-20230209111052-00844.warc.gz' --output test.gz
WARC-IP-Address: 23.220.132.93
WARC-Target-URI: https://www.tesla.com/
```
In this example the script only searches for Domain <=> IP mapping (historic DNS) - but you can easily adjust the code and extract other data. I recommend doing this. 

### cluster.idx
Example content of one index. On the left are `ip addresses` (in the top half) and `domain names` (in the bottom half).   
The domain names are `reversed`, beginning with the `TLD`. 

Followed by that is the rest of the URL, then the specific index file name, followed by the offsets - these are the addresses where the actual data is found. 

```
83,228,179,1)/wordpress/index.php/2023/05/22/22052566 20230601095112	cdx-00000.gz	18332338	207996	95
87,109,106,89)/eshop/robots.txt 20230601225058	cdx-00000.gz	18540334	188971	96
9,239,29,202)/web?page_id=1918 20230608223518	cdx-00000.gz	18729305	177239	97
91,154,241,192:8080)/apex/f?p=100:14:14786262439325::::: 20230604184114	cdx-00000.gz	18906544	185989	98
93,141,29,66)/.jp/.idcash88 20230601233028	cdx-00000.gz	19092533	198708	99
97,100,122,20)/tips-for-being-successful-in-the-workplace-during-quarantine 20230607055901	cdx-00000.gz	19291241	204305	100
abb,careers)/estonia/et/job/85467670/is-functional-analyst 20230602213339	cdx-00000.gz	19495546	211729	101
abbott,cardiovascular)/int/en/hcp/education-training/ep-emea-education/workshops.html 20230530042826	cdx-00000.gz	19707275	190777	102
abbott,ensure)/co/blog/reto-ensure-alimentandose-fuera-de-casa.html 20230604074124	cdx-00000.gz	19898052	170750	103
abbott,freestyle)/in-en/why-is-glucose-monitoring-important.html 20230529011758	cdx-00000.gz	20068802	198552	104
abbott,jobs)/global/es/job/31057790/therapy-business-manager-neurolife-pune 20230605230938	cdx-00000.gz	20267354	195819	105
ac,google)/url?q=http://motoruf.de 20230604002900	cdx-00000.gz	25175465	200615	130
ac,google)/url?q=http://steli.kr.ua 20230606063532	cdx-00000.gz	25376080	242582	131
```
The `cluster.idx` of a single crawl (there are about 5 crawls per year) is about 200MB, that why the search is slow - it happens on AWS, not inside the script. 

The cluster.idx will lead you to the indices of that crawl, called `cdx-....gz`, which contain something like this:

```
{"urlkey": "com,tesla)/", "timestamp": "20230922134848", "url": "https://www.tesla.com/", "mime": "unk", "mime-detected": "application/octet-stream", "status": "301", "digest": "3I42H3S6NNFQ2MSVX7XZKYAYSCX5QBYJ", "length": "555", "offset": "29785920", "filename": "crawl-data/CC-MAIN-2023-40/segments/1695233506420.84/crawldiagnostics/CC-MAIN-20230922134342-20230922164342-00253.warc.gz", "redirect": "https://www.tesla.com/en/"}
```
These will finally lead you to the `WARC` files, the actual `data`, called `CC-MAIN-.....warc.gz`. 

One crawl, the `WARC` files, is about `200GB` in size, some are smaller, some are larger. That's the reason we can't search directly inside the WARC files. 

## Rate Limit
Common Crawl is chronically overloaded, mainly due to AI / LLM development (so I've heard). That why switches like `--year` and `--only` were created, to limit the search on specific indexes. The script also `caches` the `index` name files, be sure to keep it that way, or you'll be blocked fast. (I played with caching the real index files but.. it doesn't make much sense, they're too big. You can download the WARC right away instead of going this intermediate step, at least that's been my way.)

Other scripts don't respect the harsh limits of `common crawl` and thus are slow, resp. don't deliver at all. 

The script isn't 100% finished, there's one `if` request you might need to play with, according to your needs, that limits the range. It's pretty simple and easy to understand, just look into the code. 

Upon findings, the script does the `calculations` to only download the specific chunk of the `WARC` files. 

## Understand the WARC files
The real juicy data is within the WARC files. It's a fancy name, but they are just compressed text. They contain requests and responses, sometimes only parts, sometimes complete `request headers` and `body` HTML - the content of the internet. This is the reason, why all of this is such a pain. I spent 6 months and quite a bit of money on lots of Terrabytes of disk space to download only a part of Common Crawl and search it locally. 

There are tools that promisse efficient search by "understanding the WARC format" - I can't speak to that, I just `grep` through them. The `problem` with the `WARC` files is not the format, it's the amount of data and the slow / rate limited download. The solution is: `patience`. 

## Usage in regards to Rate Limit
As explained before, Common Crawl does strict ratelimiting. To get around that, the script caches indices and provides two switches. 

Use either the `--year` switch to search `all` crawls of that year. Or instead use the `--only` switch to search `only one crawl per year`, starting in 2015 (before there isn't much content). 

You can search for `anything`, not strictly `domains`. But: The server side part of Common Crawls search API is a black box, and it seems to try and `deconstruct` the submitted URL into `TLD` and `domain` parts. 

## Usage
```bash
usage: cc_search.py domain [-h] [--year YEAR [YEAR ...]] [--only] 

Search for a domain in Common Crawl indices.

positional arguments:
  domain                 domain to search for in Common Crawl indices.

options:
  -h, --help            show this help message and exit
  --year YEAR [YEAR ...]
                        Specify the year(s) to search (e.g., --year 2023 2022).
  --only                Search only one index per year, starting in 2015.
```

## Help I still can't find anything
Congrats, you've likely been blocked, cause you thought the wrong thought or forgot to breath through the nose. It's really like that, Common Crawl will block you, even though you don't do anything. I worked with it for a long time. It's not your fault. 
