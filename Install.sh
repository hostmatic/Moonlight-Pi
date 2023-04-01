# Copyright 2023 Hostmatic Systems
# [IMPORTANT] 
# Tested on 32 bit Raspian Buster on Raspberry Pi 4
# If using Steam Link, the OS MUST be Buster, no later OS supported as of 2023.
# Supports hardware decoding and HEVC (H.265)

#Install updates and apps
sudo apt update
sudo apt upgrade
sudo reboot

#Install Etherwake, Moonlight and CEC Utils
#sudo apt install steamlink
curl -1sLf 'https://dl.cloudsmith.io/public/moonlight-game-streaming/moonlight-qt/setup.deb.sh' | distro=raspbian codename=buster sudo -E bash
sudo apt install moonlight-qt
sudo apt install etherwake
sudo apt install cec-utils

#Scan for TV using CEC - Use to power on TV during Boot
echo 'scan' | cec-client -s -d 1

#Install Argon software for case
curl https://download.argon40.com/argon1.sh | bash
Sudo reboot
argonone-config

#Configure Xbox controller & Check audio
#Now would be a good time to configure controller, using the Raspbian Desktop Bluetooth interface, before proceding to headless mode
#Open a web browser, and check that the controller is detected (https://gamepad-tester.com/) and that audio works (Youtube.com)

#Enable HEVC (H.265) support
#Add this line to /boot/config.txt
dtoverlay=rpivid-v4l2

#Raspi-Config settings
sudo raspi-config
#1 System options 
#   ^
#   |->S2 Audio -> Select Mai PCM (HDMI)
#   |->S5 Boot / Autologin -> Console Autologin
#   |->S6 Network at boot -> Yes
#   |->S7 Splash Screen -> Would you like to show splash screen at boot? = No

#4 Performance
#   |->P2 GPU Memory -> set to 256 MB
sudo reboot

#Run SteamLink manually just one time, to compile packages
#steamlink

#Boot auto start
sudo nano /etc/rc.local
#IN RC.LOCAL
#Custom settings
#
#Perform WOL (Only works with Ethernet)
sudo etherwake 00:00:00:00:00:00 &
#Turn on TV - Input correct address from scan
echo 'on 0.0.0.0' | cec-client -s -d 1 &
#Starts our custom boot animation - If TV is off, this won't have time to be shown
omxplayer /home/pi/steamdeckintro.mp4 &
#Starts moonlight in the user context to load user configs and start Steam (renamed in Sunshine)
#sudo -H -u pi moonlight-qt &
sudo -H -u pi moonlight-qt stream 192.168.1.42 Steam &

exit 0

#Perform network test, and adjust Moonlight bandwidth
sudo apt install speedtest-cli
speedtest-cli
#Adjust accordingly in moonlight, this step is important to ensure there is no stuttering.