Login-AzureRmAccount
$TenantId = Get-AzureRmTenant
$Subscriptions = Get-AzureRmSubscription

foreach ($sub in $Subscriptions) {
    Set-AzureRmcontext -Tenant $TenantId -SubscriptionId $sub.I
    New-AzureRmDeployment -Name 'rhipeMSP' -Location 'Australia East' -TemplateFile 'dRM.json' -TemplateParameterFile 'dRMpara1.json' -Verbose
}
