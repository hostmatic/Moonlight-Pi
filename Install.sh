 #     # #######  #####  ####### #     #    #    ####### ###  #####  
 #     # #     # #     #    #    ##   ##   # #      #     #  #     # 
 #     # #     # #          #    # # # #  #   #     #     #  #       
 ####### #     #  #####     #    #  #  # #     #    #     #  #       
 #     # #     #       #    #    #     # #######    #     #  #       
 #     # #     # #     #    #    #     # #     #    #     #  #     # 
 #     # #######  #####     #    #     # #     #    #    ###  #####  
                                                                     
  #####  #     #  #####  ####### ####### #     #  #####              
 #     #  #   #  #     #    #    #       ##   ## #     #             
 #         # #   #          #    #       # # # # #                   
  #####     #     #####     #    #####   #  #  #  #####              
       #    #          #    #    #       #     #       #             
 #     #    #    #     #    #    #       #     # #     #             
  #####     #     #####     #    ####### #     #  #####              
                                                                     
# Copyright 2023 Hostmatic Systems
# [IMPORTANT] 
# Tested on 64 bit Raspian Bullseye on Raspberry Pi 4 (8GB)
# Supports hardware decoding using HEVC (H.265)
# Update ["NAME_OF_PC"] & ["NAME_OF_APP"]

#Install updates and apps
sudo apt update
sudo apt upgrade

#Install Moonlight, Etherwake, CEC Utils and Speedtest
#sudo apt install steamlink
curl -1sLf 'https://dl.cloudsmith.io/public/moonlight-game-streaming/moonlight-qt/setup.deb.sh' | distro=raspbian codename=buster sudo -E bash
sudo apt install -y moonlight-qt
sudo apt install -y etherwake
sudo apt install -y cec-utils
sudo apt install -y speedtest-cli

#Scan for TV using CEC - Use to power on TV during Boot
echo 'scan' | cec-client -s -d 1

#Perform speed test, and adjust accordingly - This step is important to ensure there is no stuttering.
speedtest-cli

#Install Argon software for case
curl https://download.argon40.com/argon1.sh | bash

#Enable HEVC (H.265) support and increase video memory
sudo su
echo "gpu_mem=256" >> /boot/config.txt
echo "dtoverlay=rpivid-v4l2" >> /boot/config.txt
#Replace display driver when using Bullseye
sed -i 's/dtoverlay=vc4-kms-v3d/dtoverlay=vc4-fkms-v3d/g' /boot/config.txt
exit

#Boot auto start
sudo su
echo '#!/bin/sh -e' > /etc/rc.local
echo "#" >> /etc/rc.local
echo "# rc.local" >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "sudo etherwake 04:D9:F5:FA:31:20 &" >> /etc/rc.local
echo "echo 'on 0.0.0.0' | cec-client -s -d 1 &" >> /etc/rc.local
echo "sudo -H -u pi moonlight-qt stream ["NAME_OF_PC"] ["NAME_OF_APP"] &" >> /etc/rc.local
echo "" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
exit

#Final manual touches - Case config and Moonlight pair
argonone-config
moonlight-qt pair ["NAME_OF_PC"]

#Lastly disable Desktop mode - You may need to set audio mode to HDMI after reboot
sudo raspi-config
#1 System Options
#S5 Boot / Auto Login
#B2 Console Autologin

#Perform an reboot
