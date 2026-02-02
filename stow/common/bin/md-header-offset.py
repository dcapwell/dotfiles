#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = []
# ///

"""
md-header-offset.py - Adjust markdown header levels by a given offset.

Examples:
  md-header-offset.py 2 file.md      # h1 becomes h3
  md-header-offset.py -1 file.md     # h3 becomes h2
  cat file.md | md-header-offset.py 2  # from stdin
"""

import argparse
import re
import sys


def parse_args():
    parser = argparse.ArgumentParser(
        description="Adjust markdown header levels by adding/subtracting offset",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  md-header-offset.py 2 file.md        # Increase: h1 -> h3, h2 -> h4
  md-header-offset.py -1 file.md       # Decrease: h3 -> h2, h2 -> h1
  cat file.md | md-header-offset.py 2  # Read from stdin
  web.py fetch URL -o md | md-header-offset.py 2  # Pipeline with web.py
        """,
    )
    parser.add_argument(
        "offset",
        type=int,
        help="Number of levels to adjust (positive=increase, negative=decrease)",
    )
    parser.add_argument(
        "file",
        nargs="?",
        type=argparse.FileType("r"),
        default=None,
        help="Markdown file to process (reads from stdin if not provided)",
    )
    return parser.parse_args()


def adjust_header_levels(content: str, offset: int) -> str:
    """Adjust markdown header levels by adding offset to each header.

    Args:
        content: Markdown content
        offset: Number of levels to adjust (positive=increase, negative=decrease)

    Returns:
        Content with adjusted header levels

    Notes:
        - Positive offset: h1 becomes h2, h2 becomes h3, etc.
        - Negative offset: h3 becomes h2, h2 becomes h1, etc.
        - Headers cannot go below h1 (single #)
    """
    if offset == 0:
        return content

    def adjust_header(match: re.Match) -> str:
        hashes = match.group(1)
        space = match.group(2)
        current_level = len(hashes)
        new_level = current_level + offset

        # Clamp to minimum of 1 (h1)
        if new_level < 1:
            new_level = 1

        return "#" * new_level + space

    # Match lines starting with one or more # followed by a space
    return re.sub(r"^(#+)( )", adjust_header, content, flags=re.MULTILINE)


def main():
    args = parse_args()

    # Read input from file or stdin
    if args.file is not None:
        content = args.file.read()
        args.file.close()
    elif not sys.stdin.isatty():
        content = sys.stdin.read()
    else:
        print(
            "Error: No input provided. Provide a file or pipe content via stdin.",
            file=sys.stderr,
        )
        sys.exit(1)

    # Apply header adjustment
    result = adjust_header_levels(content, args.offset)

    # Output result
    print(result, end="")


if __name__ == "__main__":
    main()
