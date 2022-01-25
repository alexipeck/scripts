#parameter entered via N-able
param([String]$hostname_prefix)

#if the parameter entered is empty, the program exits with fail code (anything non-zero)
if ($hostname_prefix -eq '') {
    Write-Host "Failed to parse hostname prefix"
    return 1;
}

$gateway = Get-WmiObject -Class Win32_IP4RouteTable |
where { $_.destination -eq '0.0.0.0' -and $_.mask -eq '0.0.0.0'} |
Sort-Object metric1 | select nexthop, metric1, interfaceindex

#gets the network adapter currently being used
$adapter = Get-NetAdapter -InterfaceIndex $gateway.interfaceindex

#pulls the characters from position 13 and takes 5 characters, this should be the exact same every single time
$mac_address_last_four = $adapter.MacAddress.Substring(12, 5).Replace('-','')

#concatenate
$hostname = $hostname_prefix + '-' + $mac_address_last_four
Write-Host "New hostname:" $hostname

#get current hostname
$current_hostname = [System.Net.Dns]::GetHostName();

#gets WMI object with current hostname
$wmi_object = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $current_hostname

#rename to the new hostname
$wmi_object.Rename($hostname)

#if the rename command succeeds, it will return 0, so N-able marks it as a successful task run
#if it failed, it will return 1, so N-able marks it as a failed task, 
if ($?) {
    Write-Host "Success"
    return 0;
} else {
    return 1;
}