#!/bin/sh

file="$1"
w="$2"
h="$3"

case "$file" in
    *.tar*) tar tf "$file";;
    *.zip) unzip -l "$file";;
    *.rar) unrar l "$file";;
    *.7z) 7z l "$file";;
    *.pdf) pdftotext "$file" -;;
    *.jpg|*.jpeg|*.png|*.gif)
        # For image preview with chafa (install if needed)
        if command -v chafa > /dev/null 2>&1; then
            chafa "$file" -s "${w}x${h}"
        else
            file -b "$file"
        fi
        ;;
    *)
        # Try bat, fall back to cat
        if command -v bat > /dev/null 2>&1; then
            bat --color=always --style=numbers --line-range=:500 "$file" 2>/dev/null
        else
            cat "$file"
        fi
        ;;
esac
