#!/bin/sh

OUT=""

if [ "$(timew)" = "There is no active time tracking." ]; then
	OUT="$OUT "
else
	OUT="$OUT "
fi

echo "$OUT"
