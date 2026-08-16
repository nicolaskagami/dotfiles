#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
    pwd -P
)"

readonly FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NerdFontsSymbolsOnly"
readonly FONTCONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fontconfig/conf.d"

readonly FONT_FILES=(
    "SymbolsNerdFont-Regular.ttf"
    "SymbolsNerdFontMono-Regular.ttf"
)

readonly FONTCONFIG_FILE="10-nerd-font-symbols.conf"

command -v fc-cache >/dev/null 2>&1 || {
    printf 'Error: fontconfig is required (fc-cache not found).\n' >&2
    exit 1
}

for file in "${FONT_FILES[@]}" "$FONTCONFIG_FILE"; do
    if [[ ! -f "$SCRIPT_DIR/$file" ]]; then
        printf 'Error: missing %s\n' "$SCRIPT_DIR/$file" >&2
        exit 1
    fi
done

install -d -m 0755 "$FONT_DIR"
install -d -m 0755 "$FONTCONFIG_DIR"

for font in "${FONT_FILES[@]}"; do
    install -m 0644 "$SCRIPT_DIR/$font" "$FONT_DIR/$font"
done

install -m 0644 \
    "$SCRIPT_DIR/$FONTCONFIG_FILE" \
    "$FONTCONFIG_DIR/$FONTCONFIG_FILE"

printf 'Updating Fontconfig cache...\n'
fc-cache -f

fallbacks="$(fc-match -s -f '%{family}\n' 'Noto Sans Mono')"

if [[ "$fallbacks" != *"Symbols Nerd Font"* ]]; then
    printf 'Error: Nerd Font fallback was not registered.\n' >&2
    exit 1
fi

printf 'Installed Nerd Font symbols successfully.\n'
printf 'Fully restart Alacritty to apply the change.\n'
