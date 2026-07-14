$VMName = "ubuntu2404-test"
$VMPath = "C:\Hyper-V\$VMName"
$UbuntuISO = "C:\ISO\ubuntu-24.04.4-live-server-amd64.iso"
$SeedISO = "C:\ISO\seed.iso"
$SwitchName = "eth0"
$VlanId = 10

New-VM -Name $VMName -Generation 2 -MemoryStartupBytes 2GB -NewVHDPath "$VMPath\$VMName.vhdx" -NewVHDSizeBytes 20GB -Path $VMPath -SwitchName $SwitchName
Set-VMProcessor -VMName $VMName -Count 2
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $true -MinimumBytes 1GB -StartupBytes 2GB -MaximumBytes 4GB
Set-VMFirmware -VMName $VMName -EnableSecureBoot On -SecureBootTemplate MicrosoftUEFICertificateAuthority
Add-VMDvdDrive -VMName $VMName -Path $UbuntuISO
Add-VMDvdDrive -VMName $VMName -Path $SeedISO
Set-VMNetworkAdapterVlan -VMName $VMName -Access -VlanId $VlanId

$UbuntuDVD = Get-VMDvdDrive -VMName $VMName | Where-Object { $_.Path -eq $UbuntuISO }
$SeedDVD   = Get-VMDvdDrive -VMName $VMName | Where-Object { $_.Path -eq $SeedISO }
$Disk      = Get-VMHardDiskDrive -VMName $VMName
$Network   = Get-VMNetworkAdapter -VMName $VMName
Set-VMFirmware -VMName $VMName -BootOrder $UbuntuDVD, $Disk, $Network, $SeedDVD

Start-VM -Name $VMName

vmconnect.exe localhost $VMName