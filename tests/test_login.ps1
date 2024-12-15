try {
    # Выполняем команду docker info для проверки входа
    $dockerInfo = docker info

    if ($dockerInfo) {
        Write-Host "Docker login successful"
    } else {
        Write-Host "Docker login failed"
        exit 1
    }
} catch {
    Write-Host "Error: $_"
    exit 1
}
