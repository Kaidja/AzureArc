Configuration AzureConnectedMachineAgent {

    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -Module @{ModuleName = 'AzureConnectedMachineDsc'; ModuleVersion = '1.0.1.0'}

    $Creds = Get-AutomationPSCredential -Name "AzureArcSPN"
    $AzureADTenantID = Get-AutomationVariable -Name "AzureADTenantID"
    $AzureArcSubscriptionID = Get-AutomationVariable -Name "AzureArcSubscriptionID"
    $AzureArcResourceGroupName = Get-AutomationVariable -Name "AzureArcResourceGroupName"
    $AzureArcResourceLocation = Get-AutomationVariable -Name "AzureArcResourceLocation"

    Node InstallArcAgent
    {
        Package AzureHIMDService
        {
            Name        = 'Azure Connected Machine Agent'
            Ensure      = 'Present'
            ProductId   = '{280B4C5F-FD44-40AE-87B7-CBADDD2A3480}'
            Path        = 'https://download.microsoft.com/download/b/3/a/b3a313c0-855c-40bd-bbc1-2b80ac8a1980/AzureConnectedMachineAgent%20(1).msi'
        }

        Service HIMDS
        {
            Ensure  = 'Present'
            Name    = 'HIMDS'
            State   = 'Running'
        }

        AzureConnectedMachineAgentDsc Connect
        {
            TenantId        = $AzureADTenantID
            SubscriptionId  = $AzureArcSubscriptionID
            ResourceGroup   = $AzureArcResourceGroupName
            Location        = $AzureArcResourceLocation
            Credential      = $Creds
        }
    }
}
