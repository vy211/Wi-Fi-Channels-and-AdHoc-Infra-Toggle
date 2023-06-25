#!/bin/bash
# Set the IP address of the server
server_ip="192.168.0.175"
# Set the access point network details
ap_ssid="TP_link_0755"
ap_password="nitin80085"
# Set the ad hoc network details
adhoc_ssid="ibstest"
adhoc_password="5chrs"
video_file="http://192.168.0.175:8080/movie"
adhoc=1
# Function to check network connectivity
check_network() {
ping -c 1 $server_ip > /dev/null 2>&1
return $?
}
# Function to switch to access point mode
switch_to_ap() {
echo "Switching to access point mode..."
current_ssid=$(nmcli -t -f active,ssid dev Wi-Fi | awk -F: '$1=="yes" {print $2}')
if [ "$current_ssid" == "$ap_ssid" ]; then
	echo "Already connected to access point. Resuming playback..."
#vlc "$video_file"
#vlc --file-caching=50000 --network-caching=10000 "$video_file"
else
	sudo nmcli radio Wi-Fi on
	sudo nmcli device Wi-Fi connect "$ap_ssid" password "$ap_password"
	echo "Connected to access point. Resuming playback..."
#vlc "$video_file"
#vlc --file-caching=50000 --network-caching=10000 "$video_file"
fi
}

switch_to_adhoc() {
echo "Switching to ad hoc mode..."
adhoc_connection=$(nmcli -t -f NAME con show --active | grep "$adhoc_ssid")
if [ -n "$adhoc_connection" ]; then
	echo "Ad hoc network already created. Resuming playback..."
#vlc --file-caching=50000 --network-caching=10000 "$video_file"
#vlc "$video_file"
else
	sudo nmcli radio Wi-Fi off
	sudo iw dev
	sudo iwconfig wlp2s0 mode ad-hoc
	sudo iw dev
	sudo ip link set wlp2s0 up
	sudo rfkill unblock Wi-Fi
	sudo ip link set wlp2s0 up
	sudo iw dev wlp2s0 ibss join ibstest 2412 key d:1:5chrs
	sudo iw dev
	sudo iw dev wlp2s0 link
	sudo ip addr add 192.168.0.150/24 broadcast 192.168.0.255 dev wlp2s0
	sudo ip route add 192.168.0.0/24 dev wlp2s0
	echo "Connected to ad hoc network. Resuming playback..."
#vlc --file-caching=50000 --network-caching=10000 "$video_file"
	fi
}
# Check the network availability periodically
while true; do
check_network
	if [ $? -eq 0 ]; then
# Access point is available, switch to it
		echo "Ping Not available ap mode"
switch_to_ap
	else
# Access point is not available, switch to ad hoc mode
switch_to_adhoc
		fi
# Wait for some time before checking the network again
	sleep 2
done
