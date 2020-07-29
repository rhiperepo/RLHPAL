Login-AzureRmAccount
$tid = Get-AzureRmTenant
$Subscriptions = Get-AzureRmSubscription

foreach ($sub in $Subscriptions) {
    Set-AzureRmcontext -Tenant $tid -SubscriptionId $sub.I
    New-AzureRmDeployment -Name 'rhipeMSP' -Location 'Australia East' -TemplateFile 'dRM.json' -TemplateParameterFile 'dRMpara1.json' -Verbose
}
