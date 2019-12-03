# Zabbix Hyper-V VM basic performance counters monitoring

## Description

This Zabbix template pack automatically discovers Hyper-V virtual machines, creates for each VM synthetic host with name like "VM-Name_HOST-Name". For each synthetic VM host created autolinked template discovers performance counters:

### Disk counters

* Read Bytes/sec
* Write Bytes/sec
* Read Operations/sec
* Write Operations/sec

for each virtual disk instances

### NIC counters

* Bytes Sent/sec
* Bytes Received/sec

for each virtual NIC instances

### CPU Counters

* % Total Run Time

for each virtual CPU core

## Usage

### On every host which hosts Hyper-V virtual machines to monitoring:

#### Powershell script

Place "zabbix-discovery-vm-counters.ps1" script on secure folder. I used to make "c:\scripts\" with limited security ACL.

#### Zabbix agent configuration

Add this line to your zabbix agent:

`UserParameter=ps_script_param[*],powershell -NoProfile -ExecutionPolicy Bypass -File "C:\scripts\$1" "$2" "$3"`

### On Zabbix server:

Import templates to zabbix server:

"hyper-v-host-vm-guests-discovery.xml"

"hyper-v-vm-perfomance-counters-discovery.xml"

Add template "hyper-v-host-vm-guests-discovery.xml" to all Zabbix hosts with Hyper-V virtual machines.
