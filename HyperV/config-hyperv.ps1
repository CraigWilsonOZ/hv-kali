# Script to configure Hyper-V for a two disk system with virutal switches.

# Create new folders on D and D drives.

$vmconfigdrive = "D:"
$vmdiskdrive = "D:"

new-item "$($vmconfigdrive)\Hyper-V\Virtual Machines" -itemtype directory -Force
new-item "$($vmdiskdrive)\Hyper-V\Virtual Hard Disks" -itemtype directory -Force
new-item "$($vmdiskdrive)\Hyper-V\ISO" -itemtype directory -Force

# Seting Hyper-V properties

$vmconfiglocation = "$($vmconfigdrive)\Hyper-V\VMConfig"
$vmdisklocation = "$($vmdiskdrive)\Hyper-V\VMDisks"

$EnableEnhancedSessionMode = $True
$NumaSpanningEnabled = $True

Set-VMHost -VirtualMachinePath $vmconfiglocation -VirtualHardDiskPath $vmdisklocation `
           -EnableEnhancedSessionMode $EnableEnhancedSessionMode -NumaSpanningEnabled $NumaSpanningEnabled

# Creating Hyper-V switches

# Variables

# External Switches
$ExternalLANname = "External-LAN"
$ExternalLANnic = "Ethernet"
$ExternalWIFIname = "External-WIFI"
$ExternalWIFInic = "Wi-Fi"
# Internal Switches
$Internalname = "Internal"
# Private Switches
$Privatename = "Private"
# Management OS access
$AllowManagementOS = $True


# Creating External network aka Bridged
$LANnic =  Get-NetAdapter -Name $ExternalLANnic
New-VMSwitch -Name "$($ExternalLANname)-switch" -AllowManagementOS $AllowManagementOS -NetAdapterName $LANnic.Name

$WIFInic =  Get-NetAdapter -Name $ExternalWIFInic
New-VMSwitch -Name "$($ExternalWIFIname)-switch" -AllowManagementOS $AllowManagementOS -NetAdapterName $WIFInic.Name

# Creating Internal network
New-VMSwitch -Name "$($Internalname)-switch" -SwitchType Internal

# Creating Private network
New-VMSwitch -Name "$($Privatename)-switch" -SwitchType Private
