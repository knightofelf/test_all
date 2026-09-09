

# --------------------------------------------------------------------------
$m = New-Object -ComObject HNetCfg.HNetShare

# Public: 이더넷 3
$pub = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq "이더넷 3" }
$pubConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pub)
$pubConfig.EnableSharing(0)

# Private: 이더넷
$pri = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq "이더넷" }
$priConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pri)
$priConfig.EnableSharing(1)


Write-Host "ICS 설정 완료: Public='이더넷 3', Private='이더넷'"


Read-Host "계속하려면 Enter 키를 누르세요..."
EXIT







# --------------------------------------------------------------------------

# 관리자 권한으로 실행 필요
$SharedConnection = "이더넷 3"   # 인터넷이 연결된 어댑터
$TargetConnection = "이더넷"     # 인터넷을 공유할 대상 어댑터

$netSharingManager = New-Object -ComObject HNetCfg.HNetShare
$connections = $netSharingManager.EnumEveryConnection()

foreach ($conn in $connections) {
    $config = $netSharingManager.INetSharingConfigurationForINetConnection($conn)
    $props = $netSharingManager.NetConnectionProps($conn)

    # ICS 초기화: 모든 공유 끄기
    if ($config.SharingEnabled) {
        $config.DisableSharing()
    }
}

foreach ($conn in $connections) {
    $config = $netSharingManager.INetSharingConfigurationForINetConnection($conn)
    $props = $netSharingManager.NetConnectionProps($conn)

    # ICS 제공자 설정
    if ($props.Name -eq $SharedConnection) {
        $config.EnableSharing(0)  # 0 = ICS 제공자 (Public)
    }

    # ICS 수신자 설정
    if ($props.Name -eq $TargetConnection) {
        $config.EnableSharing(1)  # 1 = ICS 수신자 (Private)
    }
}

Write-Host "ICS 설정이 완료되었습니다."
Read-Host "계속하려면 Enter 키를 누르세요..."



# --------------------------------------------------------------------------

# 모든 어댑터의 ICS 공유 해제
$m.EnumEveryConnection | ForEach-Object {
    $c = $m.INetSharingConfigurationForINetConnection.Invoke($_)
    if ($c.SharingEnabled) {
        $c.DisableSharing()
    }
}

# 모든 어댑터의 ICS 공유 해제 (충돌 방지)
$m.EnumEveryConnection | % {
    $c = $m.INetSharingConfigurationForINetConnection.Invoke($_)
    if ($c.SharingEnabled) { $c.DisableSharing() }
}




# --------------------------------------------------------------------------
$SharedConnection = "이더넷 3"
$TargetConnection = "이더넷"

Set-NetConnectionSharing -ConnectionName $SharedConnection -SharingMode "Internet" -SharedConnection $TargetConnection





# --------------------------------------------------------------------------
$SharedConnection = "이더넷 3"   # 인터넷이 연결된 어댑터
$TargetConnection = "이더넷"     # 인터넷을 공유할 대상 어댑터

$netSharingManager = New-Object -ComObject HNetCfg.HNetShare

# 공유할 연결 찾기
$connections = $netSharingManager.EnumEveryConnection()
foreach ($conn in $connections) {
    $config = $netSharingManager.INetSharingConfigurationForINetConnection($conn)
    $props = $netSharingManager.NetConnectionProps($conn)

    if ($props.Name -eq $SharedConnection) {
        # 인터넷 연결로 설정
        if (-not $config.SharingEnabled) {
            $config.EnableSharing(0)  # 0 = 공유됨 (Public)
        }
    }

    if ($props.Name -eq $TargetConnection) {
        # ICS 대상 연결로 설정
        if (-not $config.SharingEnabled) {
            $config.EnableSharing(1)  # 1 = 공유 대상 (Private)
        }
    }
}




# --------------------------------------------------------------------------
$SharedConnection = "이더넷 3"
$TargetConnection = "이더넷"

$netSharingManager = New-Object -ComObject HNetCfg.HNetShare
$connections = $netSharingManager.EnumEveryConnection()

foreach ($conn in $connections) {
    $config = $netSharingManager.INetSharingConfigurationForINetConnection($conn)
    $props = $netSharingManager.NetConnectionProps($conn)

    if ($props.Name -eq $SharedConnection -or $props.Name -eq $TargetConnection) {
        if ($config.SharingEnabled) {
            $config.DisableSharing()
        }
    }
}

