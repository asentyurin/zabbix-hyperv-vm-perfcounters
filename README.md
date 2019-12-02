# Zabbix Hyper-V VM basic perfomance counters monitoring
## Usage
On every host which hosts VM to monitoring:
*Powershell script
Place zabbix-discovery-vm-counters.ps1 script on secured[optional] folder. I used "c:\scripts\" with limited security ACL.
*Zabbix agent configuration
Add this line to your zabbix agent:
`UserParameter=ps_script_param[*],powershell -NoProfile -ExecutionPolicy Bypass -File "C:\scripts\$1" "$2" "$3"
*Zabbix server configuration
Import templates to zabbix server:
"hyper-v-host-vm-guests-discovery.xml"
"hyper-v-vm-perfomance-counters-discovery.xml"

Add template "hyper-v-host-vm-guests-discovery.xml" to hosts with VM
