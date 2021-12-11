#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#0 or 1 for whether it'll install the specific program, program name for output on the screen and install command for choco install X
#default installed programs start with 1
$install_programs = 1,1,1,0,0,0,0
$skip_value = 3
$programs = New-Object System.Collections.ArrayList
$programs.Add([Tuple]::Create("Google Chrome", "google-chrome-x64")) | out-null
$programs.Add([Tuple]::Create("Adobe Reader DC", "adobereader")) | out-null
$programs.Add([Tuple]::Create("VLC", "vlc")) | out-null
$programs.Add([Tuple]::Create("Veeam", "veeam-endpoint-backup-free")) | out-null
$programs.Add([Tuple]::Create("Libre Office", "libreoffice")) | out-null
$programs.Add([Tuple]::Create("Thunderbird", "thunderbird")) | out-null
$programs.Add([Tuple]::Create("ImageGlass", "imageglass")) | out-null

Write-Output "Default Installing:"
$counter = 0
foreach ($program in $programs) {
    if ($install_programs[$counter] -eq 1) {
        Write-Output $program.Item1
    }
    $counter++
}

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$message = "Do you want to install optional software?"
$title = "Optional"
if ($host.ui.PromptForChoice($title, $message, $options, 1) -eq 0) {
    $counter = $skip_value
    foreach ($program in $programs | Select-Object -Skip $skip_value)
    {
        $message = "Install {0}?" -f
        $program.Item1;
        $title = "{0}" -f
        $program.Item1
        if ($host.ui.PromptForChoice($title, $message, $options, 1) -eq 0) {
            $install_programs[$counter] = 1
        }
        $counter++
    }
}

choco feature enable -n allowGlobalConfirmation
choco upgrade chocolatey -y

$counter = 0
foreach ($program in $programs)
{
    if ($install_programs[$counter] -eq 1) {
        choco install $program.Item2 -y
    }
    $counter++
}

$client = new-object System.Net.WebClient
$client.DownloadFile("https://d17kmd0va0f0mp.cloudfront.net/sos/SplashtopSOS.exe","$HOME\Desktop\ACS Remote Support.exe")

Write-Host "Done"