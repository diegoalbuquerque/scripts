$usersProfiles = Get-ChildItem -Path "C:\Users" -Directory
$users = @{}

foreach ($profile in $usersProfiles) { 
    Write-Host "[+] " -ForegroundColor Red -NoNewline
    Write-Host "Perfil Encontrado: " -NoNewline
    Write-Host "$($profile.name)" -ForegroundColor Green
}

foreach ($profile in $usersProfiles) {
    $folderPath = $profile.FullName
    if ($profile.Name -notin @("All Users", "Default", "Default User", "Public")) {
        Write-Host "[+] " -ForegroundColor Red -NoNewline
        Write-Output "Analisando o perfil do usuário: $($profile.Name)"
        
        $files = Get-ChildItem -Path $folderPath -File -Recurse -ErrorAction SilentlyContinue

        if ($files.Count -gt 0) {
            $latestFile = $files | Sort-Object LastWriteTime -Descending | Select-Object -First 1

            $lastWriteTime = $latestFile.LastWriteTime
            $fileName = $latestFile.Name

            $users[$profile.name] = @{
                name = $profile.name
                fileName = $fileName
                lastWriteTime = $lastWriteTime
            }

        } else {
            Write-Host "[+] " -ForegroundColor Red -NoNewline
            Write-Output "Nenhum arquivo encontrado no perfil de $($profile.Name)."
        }
    }
}

$users.GetEnumerator() | 
    Sort-Object { $_.Value.lastWriteTime } -Descending | 
    ForEach-Object { 
        Write-Host "[+] " -ForegroundColor Red -NoNewline
        Write-Host "USUARIO :" -NoNewline
        Write-Host "$($_.value.name)" -ForegroundColor Green

        Write-Host "[+] " -ForegroundColor Red -NoNewline
        Write-Output "Ultimo arquivo modificado: $($_.value.fileName) "

        Write-Host "[+] " -ForegroundColor Red -NoNewline
        Write-Output "Data e hora da modificação: $($_.value.lastWriteTime.ToString("dd/MM/yyyy HH:mm:ss") ) "
    }
