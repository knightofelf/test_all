$SharedConnection = "이더넷 3"   # 인터넷이 연결된 어댑터
$TargetConnection = "이더넷"     # 인터넷을 공유할 대상 어댑터


Start-Service SharedAccess


$netSharingManager = New-Object -ComObject HNetCfg.HNetShare
$connections = $netSharingManager.EnumEveryConnection()

foreach ($conn in $connections) {
    $config = $netSharingManager.INetSharingConfigurationForINetConnection($conn)
    $props = $netSharingManager.NetConnectionProps($conn)

    if ($props.Name -eq $SharedConnection) {
        if (-not $config.SharingEnabled) {
            $config.EnableSharing(0)  # 0 = ICS 제공자 (Public)
        }
    }

    if ($props.Name -eq $TargetConnection) {
        if (-not $config.SharingEnabled) {
            $config.EnableSharing(1)  # 1 = ICS 수신자 (Private)
        }
    }
}