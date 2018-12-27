
$wins = (get-vm | where {$_.name -like "*win7*"} | Select-Object -expand name)

$template = "xyz-win7-template"
$vmserver = "xyz-esx-02.xyz.local"
$vmstorage = "datastore1"
$custSpec = "Win7-AutoDeploy"

foreach ($win in $wins)

{
Update-Tools -vm $win

Start-Sleep -Seconds 480 -Verbose
Shutdown-VMGuest -VM $win 

set-vm -vm "$win" -OSCustomizationSpec $custSpec -Confirm:$False
Start-VM -vm $win -Confirm:$False
start-sleep -Seconds480
}
