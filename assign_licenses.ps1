$file = Import-CSV "C:\Users\User\Downloads\emails_and_stuff.csv"
$license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$atp_enterprise=Get-AzureADSubscribedSku | where-Object -Property SkuPartNumber -value "ATP_ENTERPRISE" -EQ
$license.SkuId = $atp_enterprise.SkuId
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$licenses.AddLicenses = $license
foreach ($user_entry in $file){
    $user=Get-AzureADUser | Where-Object -Property UserPrincipalName -Value $user_entry.Email -EQ
    Set-AzureADUserLicense -ObjectId $user.ObjectId -AssignedLicenses $licenses
}