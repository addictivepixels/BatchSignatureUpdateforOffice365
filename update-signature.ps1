# IMPORTANT: 
#     Due to the way Exchange Online is setup, this script is NOT compatible in tenents with "Outlook roaming signatures" enabled. 
#     If it is enabled in the tenent, the script will run sucessfully; however, Exchange will not override the signatures per the note from Microsoft below:
# 
# Per Microsoft:
#     Source: https://learn.microsoft.com/en-us/powershell/module/exchange/set-mailboxmessageconfiguration?view=exchange-ps 
#     This parameter doesn't work if the Outlook roaming signatures feature is enabled in your organization. 
#     Currently, the only way to make this parameter work again is to open a support ticket and ask to have Outlook roaming signatures disabled in your organization.

# Check if the Exchange Online PowerShell module is installed
if (!(Get-Module -Name ExchangeOnlineManagement)) {
  # If not installed, install the Exchange Online PowerShell module - Note: This will fail if you are not running the script as an Administrator.
  Install-Module -Name ExchangeOnlineManagement
}

# Load the Exchange Online PowerShell module
Import-Module ExchangeOnlineManagement

# Set the credentials for connecting to Exchange Online

# Connect to Exchange Online
Connect-ExchangeOnline

# Get all users with mailboxes in the tenant
$Users = Get-ExoMailbox -ResultSize Unlimited | Select-Object DisplayName,PrimarySmtpAddress

# Loop through each user
foreach ($User in $Users) {
  # Set the HTML signature for the user.
  Set-MailboxMessageConfiguration -Identity $User.PrimarySmtpAddress -SignatureHtml "<html><body><p>Regards,<br>$($User.DisplayName)</p></body></html>"

  # Set the text-only signature for the user.
  Set-MailboxMessageConfiguration -Identity $User.PrimarySmtpAddress -SignatureHtml "`nRegards,`n$($User.DisplayName)"

  # Set the mobile text-only signature for the user.
  Set-MailboxMessageConfiguration -Identity $User.PrimarySmtpAddress -SignatureTextOnMobile "`nRegards,`n$($User.DisplayName)"
}
