#### These are depending on your environment configuration and may not be needed (OPTIONAL)
$TLS12Protocol = [System.Net.SecurityProtocolType] 'Ssl3 , Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $TLS12Protocol

#Install the Azure Arc PowerShell module
Install-Module -Name Az.ConnectedMachine -Force -Verbose

#Connect Azure
Connect-AzAccount

#### You may need to change the subscription (OPTIONAL)
# Set-AzContext

#Resource Group Information
$ResourceGroup = "MyResourceGroup"
$Location = "MyResourceLocation"

#Server Name
$ServerName = ("MyServerName").ToUpper()

#Connect remote system
$PSRemoteSession = New-PSSession -ComputerName $ServerName
Connect-AzConnectedMachine -ResourceGroupName $ResourceGroup -Name $ServerName -Location $Location -PSSession $PSRemoteSession

#Uninstall Configuration Manager Agent (OPTIONAL)
Invoke-Command -ScriptBlock {
    Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "/uninstall" -NoNewWindow -Wait -PassThru
} -Session $PSRemoteSession

#Remove PowerShell remote session
Remove-PSSession -Session $PSRemoteSession

#Add the AMA Extension - this may take a few minutes to run.
$AMAExtension = @{

    Name = "AMAWindows"
    ExtensionType = "AzureMonitorWindowsAgent"
    Publisher = "Microsoft.Azure.Monitor"
    ResourceGroupName = $ResourceGroup
    MachineName = $ServerName
    Location = $Location

}

New-AzConnectedMachineExtension @AMAExtension
