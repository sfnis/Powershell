
#
# Windows PowerShell script for AD DS Deployment
#
# Change Variables as necessary

$domain = "Contoso.com"
$site = "Default Site"
Import-Module ADDSDeployment
Install-ADDSDomainController 
-ADPrepCredential (Get-Credential) 
-NoGlobalCatalog:$false 
-CreateDnsDelegation:$false 
-Credential (Get-Credential) 
-CriticalReplicationOnly:$false 
-DatabasePath "C:\Windows\NTDS" 
-DomainName $domain 
-InstallDns:$true 
-LogPath "C:\Windows\NTDS" 
-NoRebootOnCompletion:$false 
-SiteName $site 
-SysvolPath "C:\Windows\SYSVOL" 
-Force:$true