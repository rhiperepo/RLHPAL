Login-AzAccount
$TenantId = Get-AzTenant
$Subscriptions = Get-AzSubscription

foreach ($sub in $Subscriptions) {
    Set-Azcontext -Tenant $TenantId -SubscriptionId $sub
    New-AzDeployment -Name 'rhipeMSP' -Location 'Australia East' -TemplateFile 'dRM.json' -TemplateParameterFile 'dRMpara1.json' -Verbose
}
