# ------------------ Controles ------------------

. "$PSScriptRoot\creation_variables.ps1"

if (-not (Test-Path $WIN7_ISO)) {
    Write-Host "Windows 7 ISO niet gevonden op $WIN7_ISO" -ForegroundColor Red
    exit
}
if (-not (Test-Path $GUEST_ADDITIONS_ISO)) {
    Write-Host "Guest Additions ISO niet gevonden op $GUEST_ADDITIONS_ISO" -ForegroundColor Red
    exit
}
if (-not (Test-Path $VM_FOLDER)) {
    New-Item -ItemType Directory -Path $VM_FOLDER | Out-Null
}

# ------------------ VM aanmaken ------------------
VBoxManage createvm --name $VM_NAME --basefolder $VM_FOLDER --groups $GROUPNAME --ostype "Windows7_64" --register
VBoxManage modifyvm $VM_NAME --memory $MEMORY --cpus $CPUS --vram $VRAM --ioapic on --boot1 dvd --boot2 disk --nic1 intnet --intnet1 $INTNET

# ------------------ Schijf aanmaken ------------------
VBoxManage createhd --filename $VM_DISK_PATH --size 32000 --format VDI
VBoxManage storagectl $VM_NAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_DISK_PATH"

# ------------------ ISO-bestanden koppelen ------------------
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$WIN7_ISO"
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 2 --device 0 --type dvddrive --medium "$GUEST_ADDITIONS_ISO"

# ------------------ Gedeelde Map ------------------
VBoxManage sharedfolder add $VM_NAME --name "scripts" --hostpath "$SCRIPT_DIR" --automount


# ------------------ Unattended Install ------------------
VBoxManage unattended install $VM_NAME `
  --iso="$WIN7_ISO" `
  --hostname="win7-npe.npe.local" `
  --user="Administrator" `
  --password="superman" `
  --full-user-name="Administrator" `
  --locale=nl_BE `
  --country=BE `
  --time-zone="W. Europe Standard Time" `
  --start-vm=gui
  #--keyboard=be `


# Guest Additions opnieuw mounten (nadat unattended install klaar is)
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 2 --device 0 --type dvddrive --medium "$GUEST_ADDITIONS_ISO"
