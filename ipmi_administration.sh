#!/bin/sh

# Purpose: To simplify the adminstration work needed through IPMI
# Author: David Findley
# Date: April 13, 2020
# Version: 1.0

echo "IPMI Administration Tool"

read -p 'Please enter the IPMI IP address to work with: ' ipaddress
clear
ipmistatus=$(ipmitool -U ADMIN -P ADMIN -H $ipaddress chassis status | grep 'System Power' | awk '{print $4 }' )
ipmimacaddress=$(ipmitool -U ADMIN -P ADMIN -H $ipaddress lan print | grep 'MAC Address' | awk '{print $4, $14 }')
printf '\e[1;33m%s\e[0m\n'"The current IP address being used is: $ipaddress " 
printf '\e[1;33m%s\e[0m\n'"The system's MAC address is: $ipmimacaddress " 
printf '\e[1;32m%s\e[0m\n' "The system is currently powered $ipmistatus "

function ipmi_license()
{
    echo "\n New license install..."
    read -p "Please enter the license key to use for activation: " licensekey
    read -p "Installing new license on host: $ipaddress. Continue? (Y/N) " keyresponse
        if [[ $keyresponse == Y ]]; then
            /global/tmp/path/firmware/smc/tools/SUM/sum -i $ipaddress -u ADMIN -p ADMIN -c ActivateProductKey --key $licensekey
        else
            echo "Returning to menu."
        fi
}

function set_nvme()
{
    echo "\n Loading new INI file for NVME settings..."
    read -p "Would you like to continue? (Y/N) " nvmeresponse
        if [[ $nvmeresponse == Y ]]; then
            echo "Installing file nvme_gpu111419.ini. If this fails, please try manual installation."
            /global/tmp/path/firmware/smc/tools/SUM/sum -i $ipaddress -u ADMIN -p ADMIN -c ChangeBiosCfg --file /global/temp/bios_ini/file_name.ini
        else 
            echo "Returning to menu."
        fi
}

function set_master()
{
    echo "\n Loading new INI file for the master CMOS settings..."
    read -p "Would you like to continue? (Y/N) " cmosresponse
        if [[ $cmosresponse == Y ]]; then
            echo "Installing file master_gpu_111219.ini. If this fails, please try manual installation."
            /global/tmp/path/firmware/smc/tools/SUM/sum -i $ipaddress -u ADMIN -p ADMIN -c ChangeBiosCfg --file /global/temp/bios_ini/file_name.ini
        else
            echo "Returning to menu."
        fi
}

function set_pxe()
{
    printf "\nSetting chassis boot settings to PXE. This will be a persistent change."
    echo                                                                                                                                                                                                               
    read -p "Continue? (Y/N) " pxeresponse
        if [[ $pxeresponse == Y ]]; then                                                                                                                                                                                           
            ipmitool -U ADMIN -P ADMIN -H $ipaddress chassis bootdev pxe options=persistent
        else
            echo "Returning to menu."
            clear
        fi                                                                                                                                                                                                 
}
                                                                                                                                                                                                                   
function power_cycle()
{
    printf "\nRebooting the chassis..."
    read -p "Continue? (Y/N) " rebootresponse
        if [[ $rebootresonse == Y ]]; then
            ipmitool -U ADMIN -P ADMIN -H $ipaddress chassis power reset
        else
            echo "Returning to menu."
            clear
        fi
}

function menu()
{
    echo "*******************************"
    echo "1) Install new IPMI License "
    echo "2) Set NVME CMOS Settings "
    echo "3) Set Master CMSO Setting"
    echo "4) Set chassis PXE settings "
    echo "5) Power cycle the chassis "
    echo "6) Exit"
}

function read_options()
{
    local choice
    read -p "Choose an option: " number
    case $number in
        1) ipmi_license ;;
        2) set_nvme ;;
        3) set_master ;;
        4) Set chassis PXE settings
        5) Power cycle the chassis 
        6) exit 0 ;;
    esac
}

while true
    do
    menu
    read_options
done
