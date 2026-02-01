#!/usr/bin/env python3

import sys


def main():
    ignore = set()
    ignore.add("prompt eval count")
    accum = "|"
    for line in sys.stdin.read().split("\n"):
        key, value = line.split(":", 1)
        key = key.strip()
        if key in ignore:
            continue
        value = value.replace("tokens/s", "").replace("token(s)", "")
        value = value.strip()
        accum += " " + value + " |"
    print(accum)


if __name__ == "__main__":
    main()
