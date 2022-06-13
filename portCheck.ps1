if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

class Squatteur {
    [int]$Port
    [string]$ForeignIp
    [string]$Id
    [string]$ProcessName
    }

$port = Read-Host "Wich port?"

$listening = Get-NetTCPConnection | Where {$_.LocalPort -eq $port}
$process = Get-Process | where {$_.Id -eq $listening.OwningProcess}

$result=[Squatteur]::new()
$result.Port = $listening.LocalPort
$result.ForeignIp = $listening.RemoteAddress
$result.Id = $process.Id
$result.ProcessName = $process.ProcessName

if ($result.Id){
    $choice = $result | Out-GridView -Title "Select process to stop" -PassThru

    if ($choice){
        Stop-Process -Id $choice.Id -Force
        }
}
else{
    Write-Output "No process listening on that port was found"
    }


