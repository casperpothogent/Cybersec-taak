# Remote Desktop inschakelen
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

# Firewallregels
netsh advfirewall firewall set rule group="Remote Desktop" new enable=Yes
netsh advfirewall firewall add rule name="Allow RDP Port 3389" protocol=TCP dir=in localport=3389 action=allow
netsh advfirewall firewall add rule name="Allow ICMPv4-In" protocol=icmpv4 dir=in action=allow

# Statisch IP instellen
netsh interface ip set address name="Local Area Connection" static 10.10.10.2 255.255.255.0
