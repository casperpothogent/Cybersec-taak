# Script directory (automatisch pad waarin dit bestand zit)
$SCRIPT_DIR = Split-Path $MyInvocation.MyCommand.Path

# Gebruikersnaam voor VM-map
#$USER = "cindy"
$USER = $Env:Username.ToLower()
# Naam van de VM met timestamp
$VM_NAME = "Win7BlueKeep_${USER}_$(Get-Date -Format 'yyyy-MM-dd_HHmmss')"

# VM-locatie en pad naar VDI
$VM_FOLDER = "C:\Users\$USER\VirtualBox VMs"
$VM_DISK_PATH = "$VM_FOLDER\$VM_NAME\$VM_NAME.vdi"

# ISO-bestanden (Windows 7 installatie en Guest Additions)
$WIN7_ISO = "$SCRIPT_DIR\Win_7_ Ultimate_ Sp1_ En-Us_ Sept_ 2015_ x64.iso"
$GUEST_ADDITIONS_ISO = "$SCRIPT_DIR\VBoxGuestAdditions_6.1.26.iso"

# VM hardware instellingen
$MEMORY = 2048
$CPUS = 2
$VRAM = 128

# Netwerkinstellingen
$INTNET = "npe_intnet"

# VBox groep (voor organisatie in VirtualBox GUI)
$GROUPNAME = "/NPE"
