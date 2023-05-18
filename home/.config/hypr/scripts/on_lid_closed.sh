monitors_number=$(hyprctl monitors | grep Monitor | wc -l)

# If connected external display.
if [[ $monitors_number -gt 1 ]]; then
  hyprctl keyword monitor "eDP-1, disable"
fi
