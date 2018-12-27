$vms = 1..9 | % { write "xyz-win7-$_" }


$template = "xyz-win7-template"
$vmserver = "xyz-esx-02.xyz.local"
$vmstorage = "esx2-ds-01"
$custSpec = "Win7-AutoDeploy"

foreach ($vm in $vms)

{
write "machine name is $vm"
new-vm -Name $vm -template $template -vmhost $vmserver -datastore $vmstorage -OSCustomizationSpec $custSpec -Confirm:$False

}