Install-Module -Name Az.ConnectedMachine -Force -Verbose

#Connect Azure
Connect-AzAccount

#### You may need to change the subscription co next(OPTIONAL)
Set-AzContext -Subscription XXXXX-XXXXX-XXXX-XXXX-XXXXXXX

#Query AD tiering level from AD
Function Get-ADTieringLevel
{

    Param(
        $ServerName
    )

    $OU = ([adsisearcher]"(&(name=$ServerName)(objectClass=computer))").FindOne().path
                
    If($OU.Contains("Domain Controllers") -or $OU.Contains("Tier0")){
        "TIER-0"
    }
    ElseIf($OU.Contains("Tier1")){
        "TIER-1"
    }
    ElseIf($OU.Contains("Tier2")){
        "TIER-2"
    }
    Else{
        "TIERING MISSING"
    }

}

#Get the credentials and open a remote session
$ServerName = ("SRV02").ToUpper()
$Credentials = Get-Credential
$PSRemoteSession = New-PSSession -ComputerName $ServerName -Credential $Credentials

Write-Output "PowerShell remote session status: $($PSRemoteSession.State)"

#Onboard new server remotly
$ADTieringLevel = Get-ADTieringLevel -ServerName $ServerName
$Tags = @{

    "ADTieringLevel" = $ADTieringLevel;

}

$ResourceGroup = "RG-PROD-IT-AZURE-ARC-WE"
$Location = "West Europe"

$ARCOnboardingInfo = @{
    ResourceGroupName = $ResourceGroup
    Name = $ServerName
    Location = $Location
    PSSession = $PSRemoteSession
    Tag = $Tags
}

Connect-AzConnectedMachine @ARCOnboardingInfo

#Remove PowerShell session
Remove-PSSession -Session $PSRemoteSession

#Add the AMA Extension - this may take a few minutes to run
$AMAExtension = @{

    Name = "AMAWindows"
    ExtensionType = "AzureMonitorWindowsAgent"
    Publisher = "Microsoft.Azure.Monitor"
    ResourceGroupName = $ResourceGroup
    MachineName = $ServerName
    Location = $Location

}

New-AzConnectedMachineExtension @AMAExtension
