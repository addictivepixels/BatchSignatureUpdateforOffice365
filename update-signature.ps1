# This will connect to Exchange Online - you will need the Exchange Online commandlets.
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential (Get-Credential) -Authentication Basic -AllowRedirection
Import-PSSession $Session

# Get all users with a mailbox in your tenent.
$MailboxUsers = Get-Mailbox -ResultSize Unlimited | Select-Object DisplayName,Identity

# Loop through all mailbox users in your tenent.
foreach ($MailboxUser in $MailboxUsers) {
  # Create the signature for the user
  $Signature = "<html><body><p>Best regards,</p><p>$($MailboxUser.DisplayName)</p></body></html>"

  # Set the signature for the user.
  Set-MailboxMessageConfiguration -Identity $MailboxUser.Identity -SignatureHTML $Signature
}

# Remove the Exchange Online session
Remove-PSSession $Session
