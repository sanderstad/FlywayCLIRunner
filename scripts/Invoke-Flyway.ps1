
param (
    [string[]]$Arguments
)

$command = Get-Command flyway -ErrorAction SilentlyContinue
if (-not $command) {
    Write-Error "Flyway command not found. Please ensure Flyway is installed and available in the PATH."
    throw "Flyway command not found."
}

$psi = New-Object System.Diagnostics.ProcessStartInfo

$psi.FileName = $command.Source
if (-not $psi.FileName) {
    Write-Error "Flyway command source not found. Please ensure Flyway is installed correctly."
    throw "Flyway command source not found."
}

$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$psi.Arguments = $Arguments -join ' '

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $psi

$null = $process.Start()
$stdOut = $process.StandardOutput.ReadToEnd()
$stdErr = $process.StandardError.ReadToEnd()
$process.WaitForExit()
$exitCode = $process.ExitCode

return [PSCustomObject]@{
    ExitCode     = $exitCode
    Output       = $stdOut
    ErrorMessage = $stdErr
}


