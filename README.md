# CC-Search
Simple Common Crawl Web Archive search tool - intended to keep it simple and flexible: Do it in code == do it fast and precise.

## What this does - and does not
The key to understand the tool are the `indices` of Common Crawl. They are like a library index and provide only a very limited overview of the available data. It's safest to search for `URLs`, cause that's the intended `usecase`. You can of course search for other things. 

### cluster.idx
Example content of one index. On the left are `ip addresses` in the beginning and `domain names` on the bottom half. The domain names are `reversed`, beginning with the `TLD`. 

After that is the URL followed by the offsets - these are the addresses where the actual data is found. 

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
```
The `cluster.idx` of a single crawl (there are about 5 crawls per year) is about 200MB, that why the search is slow - it happens on AWS, not inside the script. 

One crawl, the `WARC` files, is about `200GB` in size, some are smaller, some are larger. That's the reason we can't search directly inside the WARC files. 

## Rate Limit
Common Crawl is chronically overloaded, mainly due to AI / LLM development (so I've heard). That why switches like `--year` and `--only` were created, to limit the search on specific indexes. The script also `caches` the `index` files, be sure to keep it that way, or you'll be blocked fast. 

Other scripts don't respect the harsh limits of `common crawl` and thus are slow, resp. don't deliver at all. 

The script isn't 100% finished, there's one `if` request you might need to play with, according to your needs, that limits the range. It's pretty simple and easy to understand, just look into the code. 

Upon findings, the script does the `calculations` to only download the specific chunk of the `WARC` files. 

## Understand the WARC files
The real juicy data is within the WARC files. It's a fancy name, but they are just compressed text. They contain requests and responses, sometimes only parts, sometimes complete `request headers` and `body` HTML - the content of the internet. This is the reason, why all of this is such a pain. I spent 6 months and quite a bit of money on lots of Terrabytes of disk space to download only a part of Common Crawl and search it locally. 

There are tools that promisse efficient search by "understanding the WARC format" - I can't speak to that, I just `grep` through them. The `problem` with the `WARC` files is not the format, it's the amount of data and the slow / rate limited download. The solution is: `patience`. 

## Usage in regards to Rate Limit
As explained before, Common Crawl does strict ratelimiting. To get around that, the script caches indices and provides two switches. 

Use either the `--year` switch to search `all` crawls of that year. Or instead use the `--only` switch to search `only one crawl per year`, starting in 2015 (before there isn't much content). 

You can search for `anything`, not strictly `urls`. 

## Usage
```bash
usage: cc_search.py [-h] [--year YEAR [YEAR ...]] [--only] url

Search for a URL in Common Crawl indices.

positional arguments:
  url                   URL to search for in Common Crawl indices.

options:
  -h, --help            show this help message and exit
  --year YEAR [YEAR ...]
                        Specify the year(s) to search (e.g., --year 2023 2022).
  --only                Search only one index per year, starting in 2015.
```

## Help I still can't find anything
Congrats, you've likely been blocked, cause you thought the wrong thought or forgot to breath through the nose. It's really like that, Common Crawl will block you, even though you don't do anything. I worked with it for a long time. It's not your fault. 
