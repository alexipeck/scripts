Add-Type -AssemblyName System.Windows.Forms
$file_browser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = "CSV/Spreadsheet (*.csv,*.xlsx)|*.csv,*.xls|All files (*.*)|*.*"
}
$null = $file_browser.ShowDialog()

$file = Import-CSV $file_browser.FileName
$license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

$atp_enterprise = Get-AzureADSubscribedSku | where-Object -Property SkuPartNumber -value "ATP_ENTERPRISE" -eq
$exchange_enterprise = Get-AzureADSubscribedSku | where-Object -Property SkuPartNumber -value "EXCHANGEENTERPRISE" -eq
$o365_business = Get-AzureADSubscribedSku | where-Object -Property SkuPartNumber -value "O365_BUSINESS" -eq
$o365_business_premium =  = Get-AzureADSubscribedSku | where-Object -Property SkuPartNumber -value "O365_BUSINESS_PREMIUM" -eq
$exchange_standard =  = Get-AzureADSubscribedSku | where-Object -Property SkuPartNumber -value "EXCHANGESTANDARD" -eq

$license.SkuId = $atp_enterprise.SkuId
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$licenses.AddLicenses = $license
foreach ($user_entry in $file){
    $user=Get-AzureADUser | Where-Object -Property UserPrincipalName -Value $user_entry.Email -EQ
    Set-AzureADUserLicense -ObjectId $user.ObjectId -AssignedLicenses $licenses
}
