#!/usr/bin/env python3

import argparse
import json
import math

from datetime import datetime

def sqft_to_dimensions(sqft):
    # use the quadratic formula!
    a = 1
    b = 0
    c = -sqft
    plus = (-b + math.sqrt(math.pow(b, 2) - 4 * a * c)) / (2 * a)
    minus = (-b - math.sqrt(math.pow(b, 2) - 4 * a * c)) / (2 * a)
    return '{0:.2f}'.format(plus)

def main():
    parser = argparse.ArgumentParser(description='Square Feet to Dimension')
    parser.add_argument('num', type=float, help='Square Feet')
    args = parser.parse_args()
    print(sqft_to_dimensions(args.num))

if __name__ == "__main__":
    main()
