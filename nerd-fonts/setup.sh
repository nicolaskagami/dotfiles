#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NerdFontsSymbolsOnly"
fontconfig_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fontconfig/conf.d"

if ! type -P fc-cache >/dev/null; then
    echo "Error: fontconfig is not installed."
    echo "Install the 'fontconfig' package first."
    exit 1
fi

mkdir -p "$font_dir"
mkdir -p "$fontconfig_dir"

cp "$script_dir/SymbolsNerdFont-Regular.ttf" "$font_dir/"
cp "$script_dir/SymbolsNerdFontMono-Regular.ttf" "$font_dir/"
cp "$script_dir/10-nerd-font-symbols.conf" "$fontconfig_dir/"

fc-cache -f

echo "Nerd Font symbols installed."
echo "Restart Alacritty to apply the change."
