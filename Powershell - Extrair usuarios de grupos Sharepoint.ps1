#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$UserName = "" 
$Password = ""
$SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $(convertto-securestring $Password -asplaintext -force)
$SiteName = ""

$siteLogado = Connect-SPOService -Url $SiteName -credential $cred

$siteLogado

Get-SPOUser -Site $SiteName | select DisplayName,LoginName,Groups | Export-Csv -Path "C:\" -encoding "unicode"ù -Delimiter ";"ù -NoTypeInformation -Append

