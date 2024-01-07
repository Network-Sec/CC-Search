# CC-Search
Simple Common Crawl Web Archive search tool - intended to keep it simple and flexible: Do it in code == do it fast and precise.

## What this does - and does not
The key to understand the tool are the `indices` of Common Crawl. They are like a library index and provide only a very limited overview of the available data. It's safest to search for `URLs`, cause that's the intended `usecase`. You can of course search for other things. 

## Info
Common Crawl is chronically overloaded, mainly due to AI / LLM development (so I've heard). That why switches like `--year` and `--only` were created, to limit the search on specific indexes. The script also `caches` the `index` files, be sure to keep it that way, or you'll be blocked fast. 

Other scripts don't respect the harsh limits of `common crawl` and thus are slow, resp. don't deliver at all. 

The script isn't 100% finished, there's one `if` request you might need to play with, according to your needs, that limits the range. It's pretty simple and easy to understand, just look into the code. 

Upon findings, the script does the `calculations` to only download the specific chunk of the `WARC` files. 

## Rate Limit
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

