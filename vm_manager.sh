#!/bin/sh

printf "\nVirtualBox VM Manager"

function vm_list()
{
    echo
    echo "Available VMs are: "
    VBoxManage list vms
}

function vm_start()
{
    echo
    VBoxManage list vms
    read -p "Please enter the name of the VM to start: " vm
    VBoxManage startvm "$vm" --type headless
}

function vm_stop()
{
    echo
    echo "List of running of VMs: "
    VBoxManage list runningvms
    read -p "Please enter the name of the VM you'd like to stop: " vm
    VBoxManage controlvm "$vm" poweroff --type headless
}

function vm_pause()
{
    echo
    echo "List of running of VMs: "
    VBoxManage list runningvms
    read -p "Please enter the name of the VM you'd like to pause: " vm
    VBoxManage controlvm "$vm" pause --type headless
}

function vm_resume()
{
    echo
    VBoxManage list vms
    read -p "Please enter the name of the VM you'd like to resume: " vm
    VBoxManage controlvm "$vm" resume --type headless
}

function vm_delete()
{
    echo
    VBoxManage list vms
    read -p "Please enter the name of the VM you'd like to delete: " vm
    echo "This will permanently delete the selected VM! "
    read -p "Press [Enter] key to continue. "
    VBoxManage unregistervm $vm --delete
}

function vm_build()
{
    echo
    read -p "Please enter the name you'd like to use for the new machine: " vm_name
    echo "Beginning VM creation process using the specified name."
    VBoxManage createvm -name "$vm_name" -ostype Ubuntu_64 -register
    echo "Setting default values for new machine $vm_name "
    VBoxManage modifyvm "$vm_name" --memory 2048 --acpi on --nic1 bridged --nictype1 82540EM --bridgeadapter1 "en0: Wi-Fi (Wireless)" --graphicscontroller vmsvga --vram 20
    echo "Creating new hard drive for $vm_name "
    VBoxManage createmedium disk --filename /Users/davidfindley/VirtualBox\ VMs/$vm_name/$vm_name.vdi --size 10000 --format VDI --variant Standard 
    echo "Adding IDE controller "
    VBoxManage storagectl "$vm_name" --name "Controller: IDE" --add ide --controller PIIX4
    echo "Adding SATA controller "
    VBoxManage storagectl "$vm_name" --name "Controller: SATA" --add sata --controller IntelAHCI
    echo "Attaching newly created storage to $vm_name "
    VBoxManage storageattach "$vm_name" --storagectl "Controller: SATA" --port 0 --device 0 --type hdd --medium /Users/davidfindley/VirtualBox\ VMs/$vm_name/$vm_name.vdi
    echo "Attaching ISO for first boot and OS installation."
    VBoxManage storageattach "$vm_name" --medium /Users/davidfindley/Documents/ubuntu-18.04.5-live-server-amd64.iso --type dvddrive --storagectl "Controller: IDE" --port 0 --device 0
    read -p "Press [Enter] to start new VM."
    echo "Starting new VM! "
    VBoxManage startvm "$vm_name" --type headless
}

function menu()
{
    echo
    printf "\n1) List Available VMs "
    printf "\n2) Start VM "
    printf "\n3) Stop VM "
    printf "\n4) Pause VM"
    printf "\n5) Resume VM"
    printf "\n6) Delete VM "
    printf "\n7) Deploy New VM "
    printf "\n8) Exit Script \n"
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
