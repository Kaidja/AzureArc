Install-Module -Name Az -Force -Verbose

#Connect Azure
Connect-AzAccount

#Set the Connection Context
Set-AzContext -Subscription XXXXX-XXXXX-XXXX-XXXX-XXXXXXX

#Create new Service Princile and assign "Azure Connected Machine Onboarding" permissions
$AARCServicePrincipal = New-AzADServicePrincipal -DisplayName "Azure-Arc-for-servers" -Role "Azure Connected Machine Onboarding"

#Print out the Service Princile information
$AARCServicePrincipal

#The following code will allow you to export the secre -https://docs.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps?view=azps-6.4.0
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AARCServicePrincipal.Secret)
$UnsecureSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

#Print out the password
$UnsecureSecret
