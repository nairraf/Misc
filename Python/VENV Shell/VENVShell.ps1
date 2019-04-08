function DoChoice($folders)
{
    Clear-Host
    Write-Host "Using VENV dir:"  $Env:VENV
    Write-Host ""
    Write-Host -ForegroundColor "Yellow" "Which Python Environment do you want to activate?"
    Write-Host "    D  -   No VENV (System Default Python)"
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
if ($Env:VENV -ne "" -and $null -ne $Env:VENV)
{
    $folders = (Get-ChildItem $Env:VENV)

    While ($true)
    {
        $choice = DoChoice $folders
        if ($choice -gt 0 -and $choice -le $folders.Count)
        {
            break
        }

        if ($choice.ToLower() -eq "d")
        {
            $host.ui.RawUI.WindowTitle = "VENV Shell - Default"
            exit
        }
    }

    $script = "" + ($folders[$choice-1].FullName.ToString()) + "\Scripts\Activate.ps1"
    if (Test-Path $script)
    {
        Write-Host ""
        Write-Host "Now Invoking: $script"
        . $script
        $host.ui.RawUI.WindowTitle = "VENV Shell - $($folders[$choice-1].BaseName)"
        exit
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
