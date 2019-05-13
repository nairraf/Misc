$script:PyEnvironments = @()
#Capture the original path before we do anything
$script:OriginalPath = $ENV:Path

function GetChoices()
{   
    $index = 0
    
    # Figure out System Environments
    foreach ( $folder in $script:PythonRootFolders)
    {
        if ( -not ($folder.BaseName).Contains("VENV") )
        {
            $index += 1
            $Name = $folder.BaseName
            $pythonEXE = ($folder.FullName.ToString()) + "\python.exe"
            ## Python 2.7 doesn't set version info in the exe? so we must call python and get the version
            #$version = ((Get-ItemProperty $pythonEXE).VersionInfo).ProductVersion
            $version = (((& $pythonEXE "--version") 2>&1).ToString().Split(" "))[1]
            # store this python env
            $script:PyEnvironments += @{
                "Type" = "System";
                "Name" = $Name;
                "Version" = $version;
                "Exe" = $pythonEXE;
                "Path" = ($folder.FullName.ToString());
            }
        }
    }

    # Figure out the VENV's
    
    foreach ( $folder in $script:VenvFolders)
    {
        # make sure there is a proper python executable and powershell activation script in the VENV
        $pythonEXE = ($folder.FullName.ToString()) + "\Scripts\python.exe"
        $pythonActivate = ($folder.FullName.ToString()) + "\Scripts\Activate.ps1"
        
        if ( (Test-Path $pythonEXE) -and (Test-Path $pythonActivate) )
        {
            $index += 1
            $venvName = $folder.BaseName
            $version = ((Get-ItemProperty $pythonEXE).VersionInfo).ProductVersion
            
            # store this python env
            $script:PyEnvironments += @{
                "Type" = "VENV";
                "Name" = $venvName;
                "Version" = $version;
                "Exe" = $pythonEXE;
                "Activate" = $pythonActivate;
            }
        }
    }

}

function DisplayChoices()
{
    Clear-Host
    # Reset Prompt back to a simmple Default - needed so the VENV Activate.ps1 works as expected
    function global:prompt {"$((pwd).Path)>"}

    Write-Host "Using Install dir:"  $Env:PYTHON_BASE
    Write-Host "Using  VENV   dir:"  $Env:PYTHON_VENV
    Write-Host ""
    Write-Host -ForegroundColor "Green" "Which Python Environment do you want to activate?"
    Write-Host -NoNewline "    D  -   Default           "
    Write-Host -ForegroundColor "Yellow" "( System Default Python )"

    for ($i = 0; $i -lt $script:PyEnvironments.Count; $i++)
    {
        Write-Host -NoNewline "    $($i+1)  -   $($script:PyEnvironments[$i]['Name']) "
        $maxNameSize = 16
        $cursize = ($script:PyEnvironments[$i]['Name']).ToString().Length
        if ( ($maxNameSize - $cursize) -gt 0)
        {
            for ($x=0; $x -le $maxNameSize - $cursize; $x++)
            {
                Write-Host -NoNewLine " "
            }
        }
         
        Write-Host -NoNewLine -ForegroundColor "Yellow" "("
        Write-Host -NoNewLine -ForegroundColor "DarkCyan" " $($script:PyEnvironments[$i]['Type'])"
        if ($script:PyEnvironments[$i]['Type'] -eq "VENV") {Write-Host -NoNewLine "  "}
        Write-Host -ForegroundColor "Yellow" " - $($script:PyEnvironments[$i]['Version']) )"
    }

    Write-Host ""
}

function SetPrompt($name, $showEnv = $True)
{
    $script:PyEnvName = $name

    if ($showEnv)
    {
        function global:prompt {
            Write-Host -NoNewline -ForegroundColor Green "($script:PyEnvName)"
            " $((pwd).Path)>"
            $host.ui.RawUI.WindowTitle = "VENV Shell - $($script:PyEnvName) - $((pwd).Path)"
        }
    } 
    else 
    {
        function global:prompt {
            " $((pwd).Path)>"
            $host.ui.RawUI.WindowTitle = "VENV Shell - $($script:PyEnvName) - $((pwd).Path)"
        }
    }
    
}

function Set-Python()
{
    While ($true)
    {
        DisplayChoices
        $choice =  Read-Host "Choice"

        if ($choice -gt 0 -and $choice -le $script:PyEnvironments.Count)
        {
            $curChoice = $script:PyEnvironments[$choice - 1]
            $showEnv = $True
            if ($curChoice['Type'] -eq "VENV")
            {
                $showEnv = $False
            }
            SetPrompt $curChoice['Name'].ToString() $showEnv
            if ($curChoice["Type"] -eq "VENV")
            {
                . $curChoice["Activate"]
            }

            if ($curChoice["Type"] -eq "System")
            {
                $ENV:Path = "$($curChoice['Path']);" + $ENV:Path
                break
            }

            break
        }

        if ($choice.ToLower() -eq "d")
        {
            SetPrompt "Default"
            # set path back to default and configure prompt and ui
            $ENV:Path = $script:OriginalPath
            break
        }
    } 
}

# main
if ($Env:PYTHON_VENV -ne "" -and $null -ne $Env:PYTHON_VENV -and $Env:PYTHON_BASE -ne "" -and $null -ne $Env:PYTHON_BASE)
{
    $script:VenvFolders = (Get-ChildItem $Env:PYTHON_VENV)
    $script:PythonRootFolders = (Get-ChildItem $Env:PYTHON_BASE)
    GetChoices
    Set-Python
} else {
    Write-Host -ForegroundColor "Red" "!! PYTHON_VENV or PYTHON_BASE environment variables not detected !!"
    Write-Host "   Please make sure you set the PYTHON_BASE and PYTHON_VENV environment variables"
    Write-Host "   PYTHON_BASE should point to the base directory where all your python installations are"
    Write-Host "   PYTHON_VENV should point to the base directory where all your python virtual environments exist"
    Write-Host ""
}
