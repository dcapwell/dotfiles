#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["requests", "beautifulsoup4", "trafilatura"]
# requires-python = ">=3.8"
# ///

# suppress SSL warning, `urllib3` doesn't like the ssl from mac...
import warnings

warnings.filterwarnings("ignore", message=".*urllib3 v2 only supports OpenSSL.*")

import argparse

import requests
from bs4 import BeautifulSoup
from trafilatura import extract


def parse_args():
    parser = argparse.ArgumentParser(description="Scrapes data from HTTP endpoints")
    parser.add_argument("url", type=str, help="URL to scrape")
    return parser.parse_args()


def main():
    args = parse_args()

    response = requests.get(args.url)
    response.raise_for_status()

    html = response.content
    soup = BeautifulSoup(html, "html.parser")
    result = extract(
        html,
        output_format="markdown",
        with_metadata=True,
        include_comments=True,
        include_tables=True,
        include_formatting=True,
        include_links=True,
        include_images=True,
        url=args.url,
    )
    print(result)


if __name__ == "__main__":
    main()
