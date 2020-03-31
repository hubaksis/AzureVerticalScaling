

filter timestamp {"[$(Get-Date -Format G)]: $_"} 
  
Write-Output "Script started." | timestamp 
 
$newTier = "PremiumV2"
$newSize = "P1v2"
# or
#$newTier = "Standard"
#$newSize = "S1"
# or
#$newTier = "Basic"
#$newSize = "B1"
# or
#$newTier = "Free"
#$newSize = "F1"

$resourceGroupName = "RG"
$appServiceName = "WebApp-Plan"


#Authenticate with Azure Automation Run As account (service principal)   
$conn = Get-AutomationConnection -Name "AzureRunAsConnection" 
Connect-AzAccount -ServicePrincipal -Tenant $conn.TenantID -ApplicationId $conn.ApplicationID -CertificateThumbprint $conn.CertificateThumbprint | out-null
Write-Output "Authenticated with Automation Run As Account." 

$appService = Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServiceName 
Write-Output "App Service Plan name: $($appService.Name)" | timestamp 
Write-Output "Current App Service Plan status: $($appService.Status), tier: $($appService.Sku.Tier), name: $($appService.Sku.Name), size: $($appService.Sku.Size)" | timestamp 

#if you want to switch to Free tier, you need to switch off AlwaysOn setting for webapps
#turning on AlwaysOn settings for all webApps to be able to switch to Free tier
#$webApps = Get-AzWebApp -AppServicePlan $appService
#foreach($webApp in $webApps){
#    # need to re-get web app to get more verbose object
#    $webApp = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $webApp.Name
#            
#    $webAppName = $webApp.Name
#    Write-Output " --- Checking '$webAppName'..."
#   if($webApp.SiteConfig.AlwaysOn){
#         Write-Output "--- Setting 'AlwaysOn' to false for the free tier..."
#         $webApp.SiteConfig.AlwaysOn = $false
#         Set-AzWebApp -WebApp $webApp
#     }
#}

$appService.Sku.Tier = $newTier
$appService.Sku.Size = $newSize
$appService.Sku.Name = $newSize
Set-AzAppServicePlan -AppServicePlan $appService
$appService = Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServiceName 
Write-Output "App Service Plan name: $($appService.Name)" | timestamp 
Write-Output "Current App Service Plan status: $($appService.Status), tier: $($appService.Sku.Tier), name: $($appService.Sku.Name), size: $($appService.Sku.Size)" | timestamp 

#turning on AlwaysOn settings back if required after scaling UP
#$webApps = Get-AzWebApp -AppServicePlan $appService
#foreach($webApp in $webApps){
#    # need to re-get web app to get more verbose object
#    $webApp = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $webApp.Name
#            
#    $webAppName = $webApp.Name
#    Write-Output " --- Checking '$webAppName'..."
#    Write-Output "--- --- Setting 'AlwaysOn' to true..."
#    $webApp.SiteConfig.AlwaysOn = $true
#    Set-AzWebApp -WebApp $webApp
#}
