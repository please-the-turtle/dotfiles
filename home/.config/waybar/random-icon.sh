icons=( "󰎏 " "󰑮 " "󰩈 " " " " " " " " " " " " ")
random_icon=${icons[ $RANDOM % ${#icons[@]} ]}
echo "$random_icon"
