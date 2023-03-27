#!/usr/bin/env python3

import argparse
import os
import glob
import subprocess

def parse_args():
  parser = argparse.ArgumentParser(description='Recursive diff of 2 different folders')
  parser.add_argument('lhs', type=str, help='First directory')
  parser.add_argument('rhs', type=str, help='Second directory')
  return parser.parse_args()

def files(path):
    return [a.replace(f'{path}/', '') for a in glob.glob(os.path.join(path, '**/*'), recursive=True)]

def diff(a, b):
    diff = []
    for f in a:
        if f not in b:
            diff.append(f)
    return diff

def diff_file(a, b):
    output = subprocess.run(f'diff {a} {b}', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if output.returncode != 0:
        print(f'diff {a} {b} had a mis-match\n{output.stdout.decode("utf-8")}\n{output.stderr.decode("utf-8")}')

def main():
  args = parse_args()

  lhs_files = set(files(args.lhs))
  rhs_files = set(files(args.rhs))
  common = lhs_files.intersection(rhs_files)
  lhs_only = diff(lhs_files, rhs_files)
  rhs_only = diff(rhs_files, lhs_files)
  if lhs_only:
      print(f'lhs only: {lhs_only}')
  if rhs_only:
      print(f'rhs only: {rhs_only}')
  if common:
      for c in common:
          diff_file(os.path.join(args.lhs, c), os.path.join(args.rhs, c))

if __name__ == "__main__":
    main()
