#!/bin/sh

# Purpose: To simplify the adminstration work needed through IPMI
# Author: David Findley
# Date: April 13, 2020
# Version: 1.0

echo "IPMI Administration Tool"

ipaddress=$1
clear

# Displaying the status of the machine connected to. MAC is required to generate a SUM key for the BIOS.
function system_summary()
{
    ipmistatus=$(ipmitool -U ADMIN -P ADMIN -H $ipaddress chassis status | grep 'System Power' | awk '{print $4 }' )
    ipmimacaddress=$(ipmitool -U ADMIN -P ADMIN -H $ipaddress lan print | grep 'MAC Address' | awk '{print $4, $14 }')
    printf "\nThe current IP address being used is: $ipaddress "
    printf "\nThe system's MAC address is: $ipmimacaddress "
    printf "\nThe system is currently powered $ipmistatus "
    echo
}

# First function since no settings can be set without a key being activated.
function ipmi_license()
{
    printf "\nNew license install..."
    read -p "Please enter the license key to use for activation: " licensekey
    echo
    read -p "Installing new license on host: $ipaddress. Continue? (Y/N) " keyresponse
        if [[ $keyresponse == Y ]]; then
            /global/tmp/path/firmware/smc/tools/SUM/sum -i $ipaddress -u ADMIN -p ADMIN -c ActivateProductKey --key $licensekey
            read -p "Press [Enter] key to continue..."
        else
            echo "Returning to menu."
            clear
        fi
}

# On our system, we can't use both NVME drives without setting this file. Use case could be different per system.
function set_nvme()
{
    printf "\nLoading new INI file for NVME settings..."
    echo
    read -p "Would you like to continue? (Y/N) " nvmeresponse
        if [[ $nvmeresponse == Y ]]; then
            echo "Installing file nvme_gpu111419.ini. If this fails, please try manual installation."
            /global/tmp/path/firmware/smc/tools/SUM/sum -i $ipaddress -u ADMIN -p ADMIN -c ChangeBiosCfg --file /global/temp/bios_ini/file_name.ini
            read -p "Press [Enter] key to continue..."
        else 
            echo "Returning to menu."
            clear
        fi
}

# Changes the boot order for the system and removes extraneous boot options.
function set_master()
{
    printf "\nLoading new INI file for the master CMOS settings..."
    echo
    read -p "Would you like to continue? (Y/N) " cmosresponse
        if [[ $cmosresponse == Y ]]; then
            echo "Installing file master_gpu_111219.ini. If this fails, please try manual installation."
            /global/tmp/path/firmware/smc/tools/SUM/sum -i $ipaddress -u ADMIN -p ADMIN -c ChangeBiosCfg --file /global/temp/bios_ini/file_name.ini
            read -p "Press [Enter] key to continue..."
        else
            echo "Returning to menu."
            clear
        fi
}

# All nodes PXE boot, this sets a persistent PXE setting in the BIOS for boot order.
function set_pxe()
{
    printf "\nSetting chassis boot settings to PXE. This will be a persistent change."
    echo                                                                                                                                                                                                               
    read -p "Continue? (Y/N) " pxeresponse
        if [[ $pxeresponse == Y ]]; then                                                                                                                                                                                           
            ipmitool -U ADMIN -P ADMIN -H $ipaddress chassis bootdev pxe options=persistent
            read -p "Press [Enter] key to continue..."
        else
            echo "Returning to menu."
            clear
        fi                                                                                                                                                                                                 
}

# Resets the power on the chassis.                                                                                                                                                                                                                   
function power_cycle()
{
    printf "\nRebooting the chassis..."
    echo
    read -p "Continue? (Y/N) " rebootresponse
        if [[ $rebootresonse == Y ]]; then
            ipmitool -U ADMIN -P ADMIN -H $ipaddress chassis power reset
            read -p "Press [Enter] key to continue..."
        else
            echo "Returning to menu."
            clear
        fi
}

function menu()
{
    echo
    echo "*******************************"
    echo
    printf "\n1) Install new IPMI License "
    printf "\n2) Set NVME CMOS Settings "
    printf "\n3) Set Master CMOS Setting"
    printf "\n4) Set chassis PXE settings "
    printf "\n5) Power cycle the chassis "
    printf "\n6) Exit"
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
    system_summary
    menu
    read_options
done
