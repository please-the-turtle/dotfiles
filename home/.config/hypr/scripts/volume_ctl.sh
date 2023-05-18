#!/usr/bin/env bash

# You can call this script like this:
# $ ./volumeControl.sh up
# $ ./volumeControl.sh down
# $ ./volumeControl.sh mute

# Script modified from these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a


function get_volume {
  pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | cut -f 2 -d '/' | cut -d '%' -f 1 | xargs
}

function is_mute {
  amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function is_mic_mute {
  amixer get Capture | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_volume_notification {
  iconSound="audio-volume-high"
  # Send the notification
  if [[ $(get_volume) -gt 100 ]] ; then
    notify-send -r 2593 -h int:value:$(get_volume) -h string:image-path:$iconSound -h string:hlcolor:#cc241d -h string:frcolor:#cc241d  "Volume: $(get_volume)"
  else
    notify-send -r 2593 -h int:value:$(get_volume) -h string:image-path:$iconSound "Volume: $(get_volume)"
  fi
}

function send_mute_notification {
  iconMuted="audio-volume-muted"
  if is_mute ; then
    notify-send -r 2593 -h string:image-path:$iconMuted "Muted"
  else
    send_volume_notification
  fi
}

function send_mic_mute_notification {
  iconMicMuted="audio-input-microphone-muted"
  iconMicUnmuted="audio-input-microphone-high"
  if is_mic_mute ; then
    notify-send -r 2593 -h string:image-path:$iconMicMuted "Mic muted"
  else
    notify-send -r 2593 -h string:image-path:$iconMicUnmuted "Mic unmuted"
  fi
}

case $1 in
  up)
    # set the volume on (if it was muted)
    amixer -D pipewire set Master on > /dev/null
    # up the volume (+ 5%)
    pactl set-sink-volume @DEFAULT_SINK@ +5% > /dev/null
    send_volume_notification
    # canberra-gtk-play -i audio-volume-change -d "changeVolume"
    ;;
  down)
    amixer -D pipewire set Master on > /dev/null
    pactl set-sink-volume @DEFAULT_SINK@ -5% > /dev/null
    send_volume_notification
    # canberra-gtk-play -i audio-volume-change -d "changeVolume"
    ;;
  mute)
    # toggle mute
    amixer -D pipewire set Master 1+ toggle > /dev/null
    send_mute_notification
    ;;
  mic_mute)
    amixer sset Capture toggle > /dev/null
    send_mic_mute_notification
    ;;
esac
