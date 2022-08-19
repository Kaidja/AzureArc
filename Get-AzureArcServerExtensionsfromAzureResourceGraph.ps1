Install-Module Az.ResourceGraph

Connect-AzAccount

$ArcServerExtensions = @()
$GraphData = Search-AzGraph -Query 'resources | where type == "microsoft.hybridcompute/machines/extensions"'
foreach($ArcServerExt in $GraphData){

    $ArchServerExtProperties = [ORDERED]@{
        Name = $ArcServerExt.id.Split("/")[8]
        ExtensionName = $ArcServerExt.name
        TenantId = $ArcServerExt.tenantId
        ResourceGroup = $ArcServerExt.resourceGroup
        ProvisioningState = $ArcServerExt.properties.provisioningState
        Type = $ArcServerExt.properties.type
        AutoUpgradeMinorVersion = $ArcServerExt.properties.autoUpgradeMinorVersion
        TypeHandlerVersion = $ArcServerExt.properties.typeHandlerVersion
        EnableAutomaticUpgrade = $ArcServerExt.properties.enableAutomaticUpgrade
    }
    
    $ArchObject = New-Object -TypeName psobject -Property $ArchServerExtProperties
    $ArcServerExtensions += $ArchObject
    
    
}
$ArcServerExtensions | Export-Csv -Path C:\Temp\ArcServersExtensions.csv -Delimiter ";" -NoTypeInformation
