#!/usr/bin/env python3

import argparse

def parse_args():
  parser = argparse.ArgumentParser(description='<REPLACE ME>')
  parser.add_argument('left', type=str, help='<REPLACE ME>')
  parser.add_argument('right', type=str, help='<REPLACE ME>')
  return parser.parse_args()

def main():
    args = parse_args()

    with open(args.left, 'r') as l:
        with open (args.right, 'r') as r:
            line_number = 0
            ll = l.readlines()
            rl = r.readlines()
            for i, (line1, line2) in enumerate(zip(ll, rl)):
                if line1 != line2:
                    print(f'Difference found at line {i}: {line1.strip()} != {line2.strip()}')
                    return

if __name__ == "__main__":
    main()
