#! /bin/env bash
rofi -show drun \
	-dpi 192 \
	-font "Inter 12" \
	-width 50 \
	-lines 10 \
	-padding 20 \
	-terminal kitty \
	-drun-display-format "{name}"
