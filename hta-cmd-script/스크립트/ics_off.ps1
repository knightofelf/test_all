

Install-Module -Name NetConnectionSharing
Import-Module NetConnectionSharing


Stop-Service SharedAccess


$target = "¿Ã¥ı≥› 3"
if ($props.Name -eq $target -and $config.SharingEnabled) {
    $config.DisableSharing()
}


$netSharingManager = New-Object -ComObject HNetCfg.HNetShare
$connections = $netSharingManager.EnumEveryConnection()

foreach ($conn in $connections) {
    $config = $netSharingManager.INetSharingConfigurationForINetConnection($conn)
    if ($config.SharingEnabled) {
        $config.DisableSharing()
    }
}

