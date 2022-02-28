#!/bin/sh

OUT=""

if [ "$(dunstctl is-paused)" = "false" ]; then
	OUT="$OUT "
else
	OUT="$OUT "
	WAITING="$(dunstctl count waiting)"
	if [ $WAITING != 0 ]; then
		OUT="$OUT ($WAITING)"
	fi
fi

echo "$OUT"
