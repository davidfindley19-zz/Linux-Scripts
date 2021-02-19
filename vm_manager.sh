#!/bin/sh

# Purpose: To allow a quick spin up of VirtualBox VMs. 
# Author: David Findley
# Date: January 28, 2021
# Version:  1.2
        #   1.0: Initial copy
        #   1.1: Cleaned up menus and added confirmations.
        #   1.2: Color added to output


# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37 

LR='\033[1;31m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
LB='\033[1;34m'

## Basic VBoxManage commands. Listing, starting, stopping, etc. 
function vm_list()
{
    echo
    echo "Available VMs are: "
    echo
    VBoxManage list vms
    echo
    echo "VMs currently ${GREEN}running${NC} on the system: "
    echo
    VBoxManage list runningvms
    echo
}

function vm_start()
{
    echo
    echo "Available VMs on the system are: "
    echo
    VBoxManage list vms
    echo
    read -p "Please enter the name of the VM to start: " vm
    echo
    if [[ ! -n $vm ]]; then
        echo "${LR}No VM selected. Returning to menu.${NC}"
    else
        echo "Starting VM ${GREEN}$vm${NC} "
        VBoxManage startvm "$vm" --type headless
    fi
}

function vm_stop()
{
    echo
    echo "List of ${GREEN}running${NC} of VMs: "
    echo
    VBoxManage list runningvms
    echo
    read -p "Please enter the name of the VM you'd like to stop: " vm
    echo
    if [[ ! -n $vm ]]; then
        echo "${LR}No VM selected. Returning to menu.${NC}"
    else
        echo "${LR}Stopping $vm${NC}"
        VBoxManage controlvm "$vm" poweroff --type headless
    fi
}

function vm_pause()
{
    echo
    echo "List of running of VMs: "
    echo
    VBoxManage list runningvms
    echo
    read -p "Please enter the name of the VM you'd like to pause: " vm
    echo
    if [[ ! -n $vm ]]; then
        echo "${LR}No VM selected. Returning to menu.${NC}"
    else
        echo "${LB}Pausing $vm${NC}"
        VBoxManage controlvm "$vm" pause --type headless
    fi
}

function vm_resume()
{
    echo
    echo "List of ${GREEN}running${NC} of VMs: "
    echo
    VBoxManage list runningvms
    echo
    read -p "Please enter the name of the VM you'd like to resume: " vm
    echo
    if [[ ! -n $vm ]]; then
        echo "${LR}No VM selected. Returning to menu.${NC}"
    else
        echo "${LB}Resuming $vm${NC}"
            VBoxManage controlvm "$vm" resume --type headless
    fi
}

function vm_delete()
{
    echo
    VBoxManage list vms
    echo
    read -p "Please enter the name of the VM you'd like to delete: " vm
    echo
    echo "${LR}This will permanently delete the selected VM: ${GREEN}$vm${NC}"
    echo
    read -p "Continue with the deletion [Y/N]" response
    if [[ $response == Y ]] || [[ $response == y ]]; then
        echo
        echo "${LR}Deleting $vm${NC} "
        # Uses --delete to delete all associated files with this VM. Removing this just unregisters it from VirtualBox.
            VBoxManage unregistervm $vm --delete
    else 
        echo
        echo "${LR}Cancelling deletion of $vm! Returning to menu.${NC}"
    fi
}

## The build function of the VM. Has default values set, but they can be edited as needed.
function vm_build()
{
    echo
    read -p "Please enter the name you'd like to use for the new machine: " vm_name
    echo "Beginning VM creation process using the name ${GREEN}$vm_name${NC}."
    # Right now it only supports Ubuntu. Might edit later to allow OS selection.
    VBoxManage createvm -name "$vm_name" -ostype Ubuntu_64 -register
    echo "${LB}Setting default values for new machine $vm_name${NC} "
    # Default machine values. Edit as needed. 
    VBoxManage modifyvm "$vm_name" --memory 2048 --acpi on --nic1 bridged --nictype1 82540EM --bridgeadapter1 "en0: Wi-Fi (Wireless)" --graphicscontroller vmsvga --vram 20
    echo "${LB}Creating new hard drive for ${GREEN}$vm_name${NC} "
    # Creates a 10 GB dynamic HDD.
    VBoxManage createmedium disk --filename /Users/davidfindley/VirtualBox\ VMs/$vm_name/$vm_name.vdi --size 10000 --format VDI --variant Standard 
    # Adding IDE and SATA controllers for the HDD to mount to and for the ISO later on.
    echo "${LB}Adding IDE controller "
    VBoxManage storagectl "$vm_name" --name "Controller: IDE" --add ide --controller PIIX4
    echo "${LB}Adding SATA controller "
    VBoxManage storagectl "$vm_name" --name "Controller: SATA" --add sata --controller IntelAHCI
    echo "${LB}Attaching newly created storage to ${GREEN}$vm_name${NC} "
    # Mounting harddrive for use
    VBoxManage storageattach "$vm_name" --storagectl "Controller: SATA" --port 0 --device 0 --type hdd --medium /Users/davidfindley/VirtualBox\ VMs/$vm_name/$vm_name.vdi
    echo "${LB}Attaching Ubuntu ISO for first boot and OS installation.${NC}"
    # Mounting the Ubuntu 18.04.05 ISO for installation
    VBoxManage storageattach "$vm_name" --medium /Users/davidfindley/Documents/ubuntu-18.04.5-live-server-amd64.iso --type dvddrive --storagectl "Controller: IDE" --port 0 --device 0
    # I found that I didn't always want to start the VM right away. Just a prompt confirming that.
    read -p "Ready to start your new VM? [Y/N]" response
    if [[ $response == Y ]] || [[ $response == y ]]; then
        echo "${GREEN}Starting new VM!${NC} "
        VBoxManage startvm "$vm_name"
    else 
        echo "${LR}Not starting $vm_name! Returning to menu.${NC}"
    fi
}

## The menu function. Just calls the function listed above in a easy to read menu. 
function menu()
{
    printf "\nVirtualBox VM Manager"
    echo
    printf "\n1) List Available VMs "
    printf "\n2) Start VM "
    printf "\n3) Stop VM "
    printf "\n4) Pause VM"
    printf "\n5) Resume VM"
    printf "\n6) Delete VM "
    printf "\n7) Deploy New VM "
    printf "\n8) Exit \n"
}

function read_options()
{
    local choice
    read -p "Choose a menu option: " number
    case $number in
        1) vm_list ;;
        2) vm_start ;;
        3) vm_stop ;;
        4) vm_pause ;;
        5) vm_resume ;;
        6) vm_delete ;;
        7) vm_build ;;
        8) exit 0 ;;
    esac
}

while true
    do
    menu
    read_options
done
