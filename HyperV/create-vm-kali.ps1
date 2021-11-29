# Create new KALI Linux VM from ISO

#Variables
$Name = "Kali-2021-3a"
$MemoryBoot = 8 * 1024 * 1024 * 1024
$MemoryMin = 8 * 1024 * 1024 * 1024
$MemoryMax = 8 * 1024 * 1024 * 1024
$CPUs = 4
$VMDisksize = 80 * 1024 * 1024 * 1024
$AutomaticStartDelay = 60
$vmconfigdrive = "D:"
$isodiskdrive = "D:"
$vmdiskdrive = "D:"
$Generation = 1
$VMData  = "$($vmconfigdrive)\Hyper-V\Virtual Machines"
$VHDpath  = "$($vmdiskdrive)\Hyper-V\Virtual Hard Disks"
$ISO = "$($isodiskdrive)\Hyper-V\ISO\kali-linux-2021.3a-installer-amd64.iso"

$ExternalWIFIname = "External-WIFI"
$Switch = "$($ExternalWIFIname)-switch"

$CheckpointType = "Disabled" # Use Standard/Production/ProductionOnly

New-VM -Name $Name -MemoryStartupBytes $MemoryBoot `
       -BootDevice VHD -NewVHDPath "$($VHDpath)\$($Name).vhdx" `
       -Path $VMData -NewVHDSizeBytes $VMDisksize -Generation $Generation -Switch $Switch

$VM = Get-VM -Name $Name

set-vm -VM $vm -ProcessorCount $CPUs -DynamicMemory `
       -MemoryStartupBytes $MemoryBoot -MemoryMinimumBytes $MemoryMin -MemoryMaximumBytes $MemoryMax `
       -AutomaticStartAction StartIfRunning -AutomaticStartDelay $AutomaticStartDelay `
       -SmartPagingFilePath $VHDpath -SnapshotFileLocation $VHDpath -CheckpointType $CheckpointType

# Add ISO
Add-VMDvdDrive -VM $VM -Path $ISO

# Update VM for booting

if ($Generation -eq 2)
{
    $VMFirmware = Get-VMFirmware -VM $VM
    $BootHDD0 = $VMFirmware.BootOrder | Where-Object {$_.Device -match "'Hard Drive on SCSI controller number 0 at location 0'"}
    $BootPXE = $VMFirmware.BootOrder | Where-Object {$_.Device -match "VMNetworkAdapter"}
    $BootISO = $VMFirmware.BootOrder | Where-Object {$_.Device -match "DvdDrive"}
    Set-VMFirmware -vm $VM -BootOrder $BootISO, $BootPXE, $BootHDD0
} else
{
    Set-VMBios -vm $VM -StartupOrder CD,IDE,LegacyNetworkAdapter,Floppy
}

# Setting Hyper-V sessions type. May not be required
# Set-VM -vm $VM -EnhancedSessionTransportType HVSocket
Set-VM -vm $VM -EnhancedSessionTransportType VMBus