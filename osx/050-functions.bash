#!/usr/bin/env bash

if is_osx ; then
  kill_display() {
    killall WindowServer
  }
fi
