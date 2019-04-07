function DoChoice()
{
    Clear-Host
    Write-Host "Using VENV dir:"  $Env:VENV
    Write-Host ""
    Write-Host -ForegroundColor "Yellow" "Which Python Environment do you want to activate?"
    for ($i = 0; $i -lt $folders.Count; $i++)
    {
        $index = $i+1
        $folder = $folders[$i].BaseName
        Write-Host "    $index  -   $folder"
    }
    Write-Host ""
    return (Read-Host "Choice")
}

# main
if ($Env:VENV -ne "" -and $Env:VENV -ne $null)
{
    $folders = (Get-ChildItem $Env:VENV)

    While ($true)
    {
        $choice = DoChoice
        if ($choice -gt 0 -and $choice -le $folders.Count)
        {
            break
        }
    }

    $script = "" + ($folders[$choice-1].FullName.ToString()) + "\Scripts\Activate.ps1"
    if (Test-Path $script)
    {
        Write-Host ""
        Write-Host "Now Invoking: $script"
        . $script
    } else {
        Write-Host -ForegroundColor "Red" "Python powershell activation script not found!"
        Write-Host "Please make sure the VENV is OK and that the following script exists:"
        Write-Host "    $script"
        Write-Host ""
        Write-Host "Press any key to continue..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
        stop-process -Id $PID
    }
} else {
    Write-Host -ForegroundColor "Red" "!! VENV environment variable not detected !!"
    Write-Host "   Please make sure you set the VENV environment variable"
    Write-Host "   It should point to the base directory where all your python virtual environments exist"
    Write-Host ""
}

