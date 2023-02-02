#!/usr/bin/env bash

function run {
  if ! pgrep $1 ; then
    $@&
  fi
}

if xrandr | rg -q 'HDMI-0 connected' ; then
  xrandr --output HDMI-0 --auto --right-of DP-2
fi

xmodmap "~/.xmodmap"
