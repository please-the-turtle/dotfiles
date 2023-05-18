if [[ ! -z $(pgrep -a "dbus-monitor" | grep "interface='org.blueman.Applet'") ]]; then
  killall dbus-monitor -Z 'dbus-monitor --session "interface='org.blueman.Applet'"'  
fi

dbus-monitor --session "interface='org.blueman.Applet'" | sed -u -n 's/.*string "input-mouse".*/pkill -RTMIN+12 waybar/p' | sh
