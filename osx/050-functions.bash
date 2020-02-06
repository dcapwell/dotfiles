#!/usr/bin/env bash

if is_osx ; then
  kill_display() {
    killall WindowServer
  }

  create_ramdisk() {
    # mount with 30g
    hdiutil attach -nomount ram://62914560
    diskutil erasevolume HFS+ "ramdisk" /dev/disk2
    echo "created volume at /Volumes/ramdisk/"
  }
fi
