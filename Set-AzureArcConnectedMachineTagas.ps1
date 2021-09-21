Connect-AzAccount

Set-AzContext XXXXX-XXXXX-XXXX-XXXX-XXXXXXX

Install-Module -Name Az.ConnectedMachine -Force -Verbose
Install-Module -Name Az -Force -Verbose

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


$ResourceGroup = "RG-PROD-IT-AZURE-ARC-WE"
$ARCConnectedMachines = Get-AzConnectedMachine -ResourceGroupName $ResourceGroup

foreach($ARCMachine in $ARCConnectedMachines){

    $ADTieringLevel = Get-ADTieringLevel -ServerName $ARCMachine.DisplayName
    $Tags = @{
        "ADTieringLevel" = $ADTieringLevel;
    }

    New-AzTag -ResourceId $ARCMachine.Id -Tag $Tags

}
