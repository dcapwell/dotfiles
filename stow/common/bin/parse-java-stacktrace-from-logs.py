#!/usr/bin/env python3

import argparse
import sys
import re

from collections import deque

def parse_args():
  parser = argparse.ArgumentParser(description='<REPLACE ME>')
  parser.add_argument('file', type=str, help='log file')
  return parser.parse_args()

def parse_traces(f, max_history=2):
    previous = deque(maxlen=max_history) # first line is the type (INFO, WARN, ERROR, etc.), second line is the type: msg
    trace = None
    for line in f:
        line = line.rstrip()
        is_trace_element = re.match(r'^\s+(at |Caused by:)', line)
        if re.match(r'^\s+(Suppressed:)', line):
            line = re.sub(r'^\s*(Suppressed):\s*', '', line)
            if trace:
                yield trace
            trace = [line.strip()]
        elif trace:
            if is_trace_element:
                trace.append(line.strip())
            else:
                yield trace
                trace = None
        elif is_trace_element:
            # found something that looks like a stack trace... 
            trace = []
            while previous:
                trace.append(previous.popleft())
            trace.append(line.strip())
        else:
            previous.append(line)
    if trace:
        yield trace

def main():
    args = parse_args()
    counts = {}
    try:
        with open(args.file, 'r') as f:
            for trace in parse_traces(f, 1):
                trace = tuple(trace[:10])
                count = 0
                if trace in counts:
                    count = counts[trace]
                counts[trace] = count + 1
    except Exception as e:
        print(f'Error: unable to process file {args.file}: {e}')
        sys.exit(1)
    top_n = 10
    seen = 0
    for trace, count in sorted(counts.items(), key=lambda i: i[1], reverse=True):
        print('###')
        print(f'count = {count}')
        print('\n'.join(trace))
        if seen >= top_n:
            break
        seen = seen + 1

if __name__ == "__main__":
    main()
