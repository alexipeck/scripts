$client = new-object System.Net.WebClient
$client.DownloadFile("https://acs-hosted-content.s3.ap-southeast-2.amazonaws.com/SentinelCleaner_x64.exe","C:\Windows\Temp\SentinelCleaner_x64.exe")
Write-Output "Running script"
$output = C:\Windows\Temp\SentinelCleaner_x64.exe 2>&1

if ($output -like "*SentinelTroubleshooter finished successfully.*") {
    Write-Output "SentinelTroubleshooter finished successfully."
    return 0;
} else {
    return 1;
}