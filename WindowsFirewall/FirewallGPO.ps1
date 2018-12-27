$gpoSession = Open-NetGPO –PolicyStore 'corp.cotoso.com\Corp - Firewall Servers Locked Down'

#$GpoSessionName = "Test - FirewallRules"
$subnets = @('10.120.2.0/24', '10.120.3.0/24', '10.70.160.0/22')
$FwRules = (Get-NetFirewallRule -GPOsession $gposession -DisplayGroup "Windows Management Instrumentation (WMI)"  |  Select-Object -expand name)

#$FwRules = (Get-NetFirewallRule -GPOsession $gposession | Get-NetFirewallAddressFilter | Where-Object -FilterScript { $_.RemoteAddress -Eq "LocalSubnet" })

ForEach ($FwRule in $FwRules)
{

#
# to select an existing GPO called "pottery: Workstations: Test Firewall" and modify an existing Advanced Firewall Rule named "Allow all 8080"
#



Set-NetFirewallRule –Name $FwRule -RemoteAddress $subnets –GPOSession $GpoSession
}

Save-NetGPO -GPOSession $GpoSession

#(Get-NetFirewallRule -GPOsession $gposession  |  Select-Object name, DisplayGroup)
#Get-NetFirewallRule -GPOsession $gposession | Get-NetFirewallAddressFilter | Where-Object -FilterScript { $_.RemoteAddress -Eq "LocalSubnet" } |  Select-Object -expand name