#! /bin/sh
sudo iw dev                       
# displays a list of available wireless devices on the system
sudo iwconfig wlp2s0 mode ad-hoc
# Change mode from infrastructure mode to ad-hoc
sudo iw dev
# again check
sudo ip link set wlp2s0 up
# start the wireless device
sudo rfkill unblock Wi-Fi
# unblock the Wifi
sudo ip link set wlp2s0 up
# start 
sudo iw dev wlp2s0 ibss join ibstest 2412 key d:1:5chrs
# security check
sudo iw dev
sudo iw dev wlp2s0 link
# Network configuration
sudo ip addr add 192.168.0.150/24 broadcast 192.168.0.255 dev wlp2s0
#ip address and bradcast ip
sudo ip route add 192.168.0.0/24 dev wlp2s0
#ip route

#In the second device, we will change the IP address from 192.168.0.150/24 to
#192.168.0.175/24 like
#“ sudo ip addr add 192.168.0.175/24 broadcast 192.168.0.255 dev wlp2s0 ”
