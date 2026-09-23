#!/usr/bin/env bash
IMG_DIR="/tmp/term-images"
mkdir -p "$IMG_DIR"
OUT="$IMG_DIR/image_$(date +%Y%m%d_%H%M%S).png"

if command -v wl-paste >/dev/null 2>&1; then
    types=$(wl-paste --list-types 2>/dev/null)
    if echo "$types" | grep -qE '^image/'; then
        if wl-paste --type image/png > "$OUT" 2>/dev/null && [ -s "$OUT" ]; then
            printf "%s" "$OUT"
            exit 0
        fi
    fi
fi

if command -v xclip >/dev/null 2>&1; then
    targets=$(xclip -selection clipboard -t TARGETS -o 2>/dev/null)
    if echo "$targets" | grep -qE 'image/png|image/jpeg'; then
        if xclip -selection clipboard -t image/png -o > "$OUT" 2>/dev/null && [ -s "$OUT" ]; then
            printf "%s" "$OUT"
            exit 0
        fi
    fi
fi

exit 1
