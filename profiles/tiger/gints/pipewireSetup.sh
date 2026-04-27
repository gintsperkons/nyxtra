#!/bin/bash

#reset pipewire

systemctl --user restart pipewire pipewire-pulse wireplumber

#create virtual devices for mic, game, music and other
pactl load-module module-null-sink sink_name=Virtual_Sink_Default
pactl load-module module-null-sink sink_name=Virtual_Sink_Mic
pactl load-module module-null-sink sink_name=Virtual_Sink_Game
pactl load-module module-null-sink sink_name=Virtual_Sink_Music
pactl load-module module-null-sink sink_name=Virtual_Sink_Other 
pactl load-module module-null-sink sink_name=Virtual_Sink_Mic_Default

sleep 0.5

pactl set-default-sink Virtual_Sink_Default