#!/usr/bin/env python3

import argparse
import re

def parse_args():
  parser = argparse.ArgumentParser(description='<REPLACE ME>')
  parser.add_argument('file', type=str, help='<REPLACE ME>')
  parser.add_argument('--warn', action='store_true', help='<REPLACE ME>')
  return parser.parse_args()

def _strip_timestamps(line):
    return re.sub('\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d', 'TIMESTAMP', line)

def _clean_threads(line):
    return re.sub('\[(.*)\]', lambda result: '[' + re.sub('(-?\d+)', '-num', result.group(1)) + ']', line)

LEVELS = ['DEBUG', 'INFO', 'WARN', 'ERROR']

def main():
  args = parse_args()
  with open(args.file, 'r') as r:
      previous_line = None
      group_by = {}
      for line in r:
          line = line.replace('\n', '')
          line = _strip_timestamps(line)
          line = _clean_threads(line)
          if not line:
              continue
          first_word = line.split()[0]
          if first_word in LEVELS:
              if previous_line:
                accum = group_by.get(previous_line, 0)
                group_by[previous_line] = accum + 1
              previous_line = line
          else:
              previous_line = f'{previous_line}\n{line}'
  if previous_line:
    accum = group_by.get(previous_line, 0)
    group_by[previous_line] = accum + 1

  for k, v in group_by.items():
      first_word = k.split()[0]
      if args.warn and first_word not in ['WARN', 'ERROR']:
          continue
      if v > 1:
          print(f'Line\n{k}\nCount: {v}')

if __name__ == "__main__":
    main()
