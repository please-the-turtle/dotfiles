sleep 3 # Needs to get valid values from upower

mouse_id=`bluetoothctl devices Connected | grep -m 1 -i mouse | grep -P -o "([0-9A-F]{2}:){5}[0-9A-F]{2}"`

if [[ -z $mouse_id ]]; then
  echo -e "\nBluetooth mouse not conencted"
else
  mouse_info=`bluetoothctl info $mouse_id`
  percentage=`echo $mouse_info | grep -P -o "Battery Percentage:.*\(\d+" | grep -P -o "\d+$"`
  name=`echo $mouse_info | grep -P -o "Name:.*$" |  sed "s/Alias.*//g"`
  echo -e " 󰍽 $percentage%\n$name"
fi
