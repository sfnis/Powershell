#Set Variables
$vCenterFQDN = "labvc1.homelab.local"
$SmtpServer = "smtp.homelab.local"
$SmtpPort = "25"
$FromEmail = "vcenter@homelab.local"
$MaxTaskEventsAge = "90"
$MinutesToRepeat = "10"
$AdminEmail = "admin@homelab.local"

#Add the Alarm Definitions to be configured here
$alarms = @("Datastore usage on disk", "vSphere HA host status", "vSphere HA failover in progress", "Host connection and power state", "Host error", "Health status monitoring", "Host CPU usage", "Host memory usage")

Connect-VIServer $vCenterFQDN

#Configure vCenter Mail Settings
Get-AdvancedSetting -Entity $vCenterFQDN -Name mail.smtp.server | Set-AdvancedSetting -Value $SmtpServer -Confirm:$false
Get-AdvancedSetting -Entity $vCenterFQDN -Name mail.smtp.port | Set-AdvancedSetting -Value $SmtpPort -Confirm:$false
Get-AdvancedSetting -Entity $vCenterFQDN -Name mail.sender | Set-AdvancedSetting -Value $FromEmail -Confirm:$false

#Configure vCenter Task and Events Database Retention
Get-AdvancedSetting -Entity $vCenterFQDN -Name task.maxAgeEnabled | Set-AdvancedSetting -Value $true -Confirm:$false
Get-AdvancedSetting -Entity $vCenterFQDN -Name task.maxAge | Set-AdvancedSetting -Value $MaxTaskEventsAge -Confirm:$false
Get-AdvancedSetting -Entity $vCenterFQDN -Name event.maxAgeEnabled | Set-AdvancedSetting -Value $true -Confirm:$false
Get-AdvancedSetting -Entity $vCenterFQDN -Name event.maxAge | Set-AdvancedSetting -Value $MaxTaskEventsAge -Confirm:$false

#Configure the Email Action on the defined list of alarms
foreach ($alarm in $alarms) {
  Get-AlarmDefinition -Name $alarm | %{
        #Remove Email Action if already configured
     $_ | Get-AlarmAction -ActionType "SendEmail" | Remove-AlarmAction -Confirm:$false 
     #Set the number of Minutes between Repeat Emails for Yellow to Red Triggers
     $_ | Set-AlarmDefinition -ActionRepeatMinutes $MinutesToRepeat;   
     #Create the Send Email Action and set to the admin email                 
     $_ | New-AlarmAction -Email -To $AdminEmail | %{
        #Set to Email Once when Trigger from Green to Yellow
        $_ | New-AlarmActionTrigger -StartStatus "Green" -EndStatus "Yellow" 
        #Remove the Yellow to Red Trigger so we can set it to Repeat
        $_ | Get-AlarmActionTrigger | Where{$_.StartStatus -eq "Yellow" -and $_.EndStatus -eq "Red"}  | Remove-AlarmActionTrigger -Confirm:$false
        #Set to Email Repeat when Trigger from Yellow to Red
        $_ | New-AlarmActionTrigger -StartStatus "Yellow" -EndStatus "Red" -Repeat
        #Set to Email Once when Trigger from Red to Yellow
        $_ | New-AlarmActionTrigger -StartStatus 'Red' -EndStatus 'Yellow'
        #Set to Email Once when Trigger from Yellow to Green
        $_ | New-AlarmActionTrigger -StartStatus 'Yellow' -EndStatus "Green"
     }
  }
}

Disconnect-VIServer