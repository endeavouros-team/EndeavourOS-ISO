#!/bin/bash

# GeoIP lookup (gets the two-letter country code)
country=$(curl -s https://ipinfo.io/country | tr -d '\n')

# Map country code to keyboard layout
case "$country" in
  DE) layout="de" ;;      # Germany
  FI) layout="fi" ;;      # Finnland
  FR) layout="fr" ;;      # France
  IT) layout="it" ;;      # Italy
  ES) layout="es" ;;      # Spain
  JP) layout="jp" ;;      # Japan
  CN) layout="us" ;;      # China: US physical layout + IME (e.g., Pinyin)
  US|CA) layout="us" ;;   # United States / Canada
  *) layout="us" ;;       # Default fallback
esac

# Pre-set the layout in Plasma config before it's loaded
kwriteconfig6 --file kxkbrc --group Layout --key LayoutList "$layout"
kwriteconfig6 --file kxkbrc --group Layout --key Use --type bool true
kwriteconfig6 --file kxkbrc --group Layout --key ResetOldOptions --type bool true
kwriteconfig6 --file kxkbrc --group Layout --key SwitchMode "Global"
