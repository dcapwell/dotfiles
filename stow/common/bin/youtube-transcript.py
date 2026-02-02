#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "youtube-transcript-api",
#     "yt-dlp",
# ]
# ///

import sys
import re
import json
from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api.formatters import TextFormatter
import yt_dlp


def fetch_video_metadata(video_id: str) -> dict:
    """Fetch video metadata using yt-dlp."""
    url = f"https://www.youtube.com/watch?v={video_id}"
    ydl_opts = {
        "quiet": True,
        "no_warnings": True,
        "extract_flat": False,
        "skip_download": True,
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=False)
        return {
            "title": info.get("title", "Unknown Title"),
            "channel": info.get("channel", info.get("uploader", "Unknown Channel")),
            "channel_url": info.get("channel_url", info.get("uploader_url", "")),
        }


def print_markdown_header(original_url: str, metadata: dict):
    """Print the markdown header with video info."""
    channel = metadata["channel"]
    title = metadata["title"]
    channel_url = metadata["channel_url"]

    print(f"# [[{channel}]] - {title}")
    print()
    print(f"- **URL:** [Video]({original_url})")
    if channel_url:
        print(f"- **Channel URL:** [{channel}]({channel_url})")
    print()
    print("## Transcript")
    print()


if len(sys.argv) < 2:
    print("Usage: provide YouTube URL or video_id as argument", file=sys.stderr)
    sys.exit(1)

url_or_id = sys.argv[1]

# Extract video ID from URL if it's a full URL
video_id_match = re.search(r"(?:v=|/)([a-zA-Z0-9_-]{11})", url_or_id)
if video_id_match:
    video_id = video_id_match.group(1)
else:
    # Assume it's already a video ID
    video_id = url_or_id

# Build canonical URL for display if only video ID was provided
if url_or_id == video_id:
    original_url = f"https://www.youtube.com/watch?v={video_id}"
else:
    original_url = url_or_id

try:
    # Fetch metadata first
    metadata = fetch_video_metadata(video_id)
    print_markdown_header(original_url, metadata)

    # Fetch and print transcript
    ytt_api = YouTubeTranscriptApi()
    transcript = ytt_api.fetch(video_id)
    formatter = TextFormatter()
    print(formatter.format_transcript(transcript))
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
