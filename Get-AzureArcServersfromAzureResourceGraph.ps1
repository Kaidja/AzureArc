Install-Module Az.ResourceGraph

Connect-AzAccount

Get-AzSubscription

# Set the Azure context, if needed
#Set-AzContext XXXXXXXXXXXXXXXXXXXXXXXXX

# Print out all Az.ResourceGraph module commands
#Get-Command -Module Az.ResourceGraph

$ArcServers = @()
$GraphData = Search-AzGraph -Query 'resources | where type == "microsoft.hybridcompute/machines"'
foreach($ArcServer in $GraphData){

    $ArchServerProperties = [ORDERED]@{
        Name = $ArcServer.name
        TenantId = $ArcServer.tenantId
        ResourceGroup = $ArcServer.resourceGroup
        SubscriptionId = $ArcServer.subscriptionId
        Tags = $ArcServer.tags
        OsType = $ArcServer.properties.osType
        Status = $ArcServer.properties.status
        OSVersion = $ArcServer.properties.osVersion
        VMId = $ArcServer.properties.vmId
        LastStatusChange = $ArcServer.properties.lastStatusChange
        LastStatusChangeInDays = (New-TimeSpan -Start $ArcServer.properties.lastStatusChange -End (Get-Date)).Days
        AgentVersion = $ArcServer.properties.agentVersion
        ErrorDetails = $ArcServer.properties.errorDetails
        OSSku = $ArcServer.properties.osSku
    }
    
    $ArchObject = New-Object -TypeName psobject -Property $ArchServerProperties
    $ArcServers += $ArchObject
    
    
}
# Export data out to a CSV file
$ArcServers | Export-Csv -Path C:\Temp\ArcServers.csv -Delimiter ";" -NoTypeInformation

