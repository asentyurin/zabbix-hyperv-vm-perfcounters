param(
	[Parameter(Mandatory=$True,HelpMessage="Discovery type: GetVM, GetVMDisks, GetVMCPUs, GetVMNICs")]
	[string]$discoveryType,

	[Parameter(Mandatory=$False,HelpMessage="fakeVMName: VMname_HOSTname")]
    [string]$fakeVMname
)

#Collect all running VMs from host
$VMs = Get-VM | Where-Object -Property State -Like Running

#Get hostname
$hostName = Get-WmiObject win32_computersystem | Select-Object -ExpandProperty name

#If DiscoveryType parameter is set to VM send JSON collection of VMs to Zabbix and exit
if ($DiscoveryType -eq 'GetVM') {
   [pscustomobject]@{
        "data" = @(
            foreach ($objItem in $VMs) {
                [pscustomobject]@{
                "{#VMNAME}" = $objItem.Name
                "{#VMHOST}" = $hostname
                }
            }
        )
   } | ConvertTo-Json
    exit
}

##If got 2 parameters send JSON collection of VM counter instances to Zabbix and exit
if ($psboundparameters.Count -eq 2) {
    
    $Name = $fakeVMName.Replace("_" + $hostName, '')
    
    switch ($discoveryType)
        {
            ('GetVMDisks'){
                $ItemType = "{#VMDISK}"
                $Results =  (Get-Counter -Counter '\Hyper-V Virtual Storage Device(*)\Read Bytes/sec' -ErrorAction SilentlyContinue).CounterSamples  | Where-Object  {$_.InstanceName -like '*-'+$Name+'-*'} | select InstanceName
            }

            ('GetVMNICs'){
                $ItemType = "{#VMNIC}"
                $Results = (Get-Counter -Counter '\Hyper-V Virtual Network Adapter(*)\Bytes Sent/sec' -ErrorAction SilentlyContinue).CounterSamples | Where-Object  {$_.InstanceName -like $Name+'_*'} | select InstanceName
            }

            ('GetVMCPUs'){
                 $ItemType  ="{#VMCPU}"
                 $Results = (Get-Counter -Counter '\Hyper-V Hypervisor Virtual Processor(*)\% Total Run Time'  -ErrorAction SilentlyContinue).CounterSamples | Where-Object {$_.InstanceName -like $Name+':*'} | select InstanceName
            }
            
            default {$Results = "Bad Request"; exit}
        }

    [pscustomobject]@{
        "data" = @(
            foreach ($objItem in $Results) {
                [pscustomobject]@{
                "{#VMHOST}" = $hostName
                $ItemType = $objItem.InstanceName
                }
            }
        )
    } | ConvertTo-Json
    exit
}