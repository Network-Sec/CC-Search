#!/usr/bin/env python3

import argparse
import requests
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
import gzip, io, zlib, json, re
from time import sleep

DEBUG = True

# Be authentic! Websites and APIs much like!
browser_headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "de,en-US;q=0.7,en;q=0.3",
    "Accept-Encoding": "gzip, deflate",
    "Upgrade-Insecure-Requests": "1",
}


# Create an instance of the fake UserAgent
ua = UserAgent()

def decode_response(response):
    content_encoding = response.headers.get('Content-Encoding', '')
    try:
        if 'gzip' in content_encoding:
            # Handle Gzip compression
            compressed_data = response.text.encode('iso-8859-1')
            decompressed_data = gzip.GzipFile(fileobj=io.BytesIO(compressed_data)).read()
            return decompressed_data.decode('utf-8')

        elif 'deflate' in content_encoding:
            # Handle Deflate compression
            compressed_data = response.text.encode('iso-8859-1')
            decompressed_data = zlib.decompress(compressed_data)
            return decompressed_data.decode('utf-8')
        else:
            # No compression, use 'response.text' as-is
            return response.text
    except:
        return response.text

def repair_json(text):
    return json.loads("[" + text.rstrip().replace("\n", ',') + "]")

def fetch_index_names():
    index_page_url = "https://data.commoncrawl.org/crawl-data/index.html"
    browser_headers['User-Agent'] = ua.random
    response = requests.get(index_page_url, headers=browser_headers)

    try:
        if response.status_code != 200:
            with open("CC_Index_cache.html", "r") as f:
                page_content = f.readlines()
        else:
            page_content = decode_response(response)
            with open("CC_Index_cache.html", "w") as f:
               f.write(page_content)

        soup = BeautifulSoup(page_content, 'html.parser')
        index_links = soup.select('td a')
        index_names = [link.get_text() for link in index_links if link.get_text().startswith("CC")]
        return index_names
    except:
        return []


def search_in_index(index, url):
    api_url = f"https://index.commoncrawl.org/{index}-index?url={url}&output=json"
    browser_headers['User-Agent'] = ua.random

    if DEBUG:
        print(api_url)

    response = requests.get(api_url, headers=browser_headers)
    response_text = decode_response(response)
    if DEBUG:
        print(response.status_code)
    return response_text, response.status_code

def main():
    parser = argparse.ArgumentParser(description="Search for a URL in Common Crawl indices.")
    parser.add_argument("url", help="URL to search for in Common Crawl indices.")
    parser.add_argument("--year", nargs="+", type=int, help="Specify the year(s) to search (e.g., --year 2023 2022).")
    parser.add_argument("--only", action="store_true", help="Search only one index per year, starting in 2015.")

    args = parser.parse_args()

    url_to_search = args.url

    if not args.year and not args.only:
        print("Warning: Common Crawl may block due to rate limit.")

    # Fetch the index names
    index_names = fetch_index_names()

    if not index_names:
        print("No index names found.")
        return

    results = years = []
    if args.only:
         years = [i for i in reversed(range(2015,2024))]
    elif args.year:
         years = [str(y) for y in reversed(args.year)]

    yc = 0

    for index in index_names:
        # Check if we should limit to one index per year
        if args.only and len(years) <= yc:
            break

        if ( args.only and str(years[yc]) in index ) or ( args.year and any(str(year) in index for year in years) ):
            sleep(1)
            yc += 1
            text, status = search_in_index(index, url_to_search)
            if status == 200:
                results.append(repair_json(text))

    for json_array in results:
        for result in json_array:
            # Extract relevant data
            offset = int(result['offset'])
            length = int(result['length'])
            filename = result['filename']

            # Construct the URL for downloading
            download_url = f"https://data.commoncrawl.org/{filename}"

            # Calculate the byte range
            start_byte = offset
            end_byte = offset + length - 1
            byte_range = f"bytes={start_byte}-{end_byte}"

            # Construct the curl command
            curl_command = f"curl -H 'Range: {byte_range}' '{download_url}' --output test.gz"
            print(curl_command)

            headers = {'Range': byte_range}

            response = requests.get(download_url, headers=headers)
            try:
                decompressed_data = gzip.decompress(response.content)
            except:
               continue

            try:
                with open(f"cc_domain_search_results_for_{url_to_search}.txt", "a") as f:
                    f.write(decompressed_data.decode('utf-8'))
            except:
               print("Couldn't write full output to file")

            decoded_data = decompressed_data.decode('utf-8')

            # Use regular expressions to extract WARC-IP-Address and WARC-Target-URI
            ip_address_matches = re.findall(r'WARC-IP-Address: (.+)', decoded_data)
            target_uri_matches = re.findall(r'WARC-Target-URI: (.+)', decoded_data)

            # Print the extracted values
            for ip_address, target_uri in zip(ip_address_matches, target_uri_matches):
                print(f"WARC-IP-Address: {ip_address.strip()}")
                print(f"WARC-Target-URI: {target_uri.strip()}")

if __name__ == "__main__":
   main()
