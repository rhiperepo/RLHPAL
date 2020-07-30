<# Azure_EA_to_Plan_Migration-Add_Rhipe_Owner_Permission.ps1 - 29/07/2020 v1.1

SCRIPT ADDS RHIPE AS OWNER TO EA SUBSCRIPTION PRIOR TO MIGRATION TO CSP/AzurePlan.

SCRIPT NEEDS TO BE RUN PRIOR TO MIGRATION AS A PREREQUISITE TASK WITH THE CREDENTIALS OF A CURRENT SUBSCRIPTION ONWER.

POWERSHELL MODULES REQUIRED: Az,

MICROSOFT PROCESSES DO NOT ADD RHIPE AS OWNER OF SUBSCRIPTION DURING MIGRATION. THIS SCRIPT CORRECTS THAT ISSUE.
NOT RUNNING THIS SCRIPT COULD HAVE FINANCIAL AND FUNCTIONALITY IMPLICATIONS FOR PARTNERS/CUSTOMERS.

WRITTEN BY: Joel Dickins - joel.dickins@rhipe.com
Modified By : Oaker Min - ominbruce@rhipe.com
MIGRATON CONTACT: Oaker Min - ominbbruce@rhipe.com

OTHER INQUIRIES: Please direct to your rhipe Account Manager #>

Write-Host "`n`tRhipe Azure Migration - EA to Azure Plan" -ForegroundColor Magenta
Write-Host
Write-Host "`n`tThis script grants rhipe permissions over an EA subscription prior to the migration process " -ForegroundColor Yellow
Write-Host
Write-Host "`n`tScript should be run with credentials of an account with Owner Role on the subscriptions. " -ForegroundColor Yellow


# SET RHIPE GUID FOR DELEGATION OF PERMISSIONS
Write-Host "`n`tPlease enter the Object ID provided by your migration contact: " -ForegroundColor Cyan -nonewline;
$choice = Read-Host
$ObjectId = $choice

## LOGIN TO AZURE PS
Connect-AzAccount

# GET ALL AVAILABLE SUBSCRIPTION IDs AND PLACE INTO ARRAY
#$Subscriptions = $null
$Subscriptions = @(Get-AzSubscription).Id
$TenantId = @(Get-AzTenant).Id

# START PARTNER DELEGATION PERMISSION
foreach ($Sub in $Subscriptions)
{
     Set-AzContext -TenantId $TenantId -SubscriptionId $Sub 
     New-AzRoleAssignment -ObjectId $ObjectId -RoleDefinitionName "Owner" -Scope /subscriptions/$Sub
}
# END PARTNER DELEGATION PERMISSION

# CHECK PARTNER PERMISSION
foreach ($Sub in $Subscriptions)
{
    $CheckPartner = "Owner"
    $CheckPartner = Get-AzRoleAssignment -ObjectId $ObjectId | Where {$_.RoleDefinitionName -eq "Owner"} | select-object -ExpandProperty RoleDefinitionName
        if($CheckPartner)
        {
            Write-Host "SUCCESSFUL - Partner Admin Permissions on $Sub" -ForegroundColor Green
        }
    else
        {
            Write-Host "FAILED - Partner Admin Permissions on $Sub" -ForegroundColor Yellow
        }
}

Write-Host "`n`tScript copmpleted" -ForegroundColor Magenta
# END OF SCRIPT
