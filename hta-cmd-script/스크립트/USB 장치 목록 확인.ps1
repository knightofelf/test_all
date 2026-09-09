

Import-Module PnpDevice
Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false
Start-Sleep -Seconds 2
Get-PnpDevice -FriendlyName "*USB*" | Enable-PnpDevice -Confirm:$false

