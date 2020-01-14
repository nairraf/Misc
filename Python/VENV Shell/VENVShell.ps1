#Capture the original path before we do anything
$script:OriginalPath = $ENV:Path

function GetChoices()
{   
    $script:PyEnvironments = @()
    $index = 0
    
    # Figure out System Environments
    foreach ( $folder in $script:PythonRootFolders)
    {
        if ( -not ($folder.BaseName).Contains("VENV") )
        {
            $Name = $folder.BaseName
            $pythonEXE = ($folder.FullName.ToString()) + "\python.exe"
            if ( Test-Path $pythonEXE)
            {
                $index += 1
                ## Python 2.7 doesn't set version info in the exe? so we must call python and get the version
                #$version = ((Get-ItemProperty $pythonEXE).VersionInfo).ProductVersion
                $version = (((& $pythonEXE "--version") 2>&1).ToString().Split(" "))[1]
                $architecture = (& $pythonEXE -c "import platform;print(platform.architecture()[0])").ToString()
                # store this python env
                $script:PyEnvironments += @{
                    "Type" = "System";
                    "Name" = $Name;
                    "Version" = $version;
                    "Exe" = $pythonEXE;
                    "Path" = ($folder.FullName.ToString());
                    "Architecture" = $architecture;
                }
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
            ## Python 2.7 doesn't set version info in the exe? so we must call python and get the version
            #$version = ((Get-ItemProperty $pythonEXE).VersionInfo).ProductVersion
            $version = (((& $pythonEXE "--version") 2>&1).ToString().Split(" "))[1]
            $architecture = (& $pythonEXE -c "import platform;print(platform.architecture()[0])").ToString()
            
            # store this python env
            $script:PyEnvironments += @{
                "Type" = "VENV";
                "Name" = $venvName;
                "Version" = $version;
                "Exe" = $pythonEXE;
                "Activate" = $pythonActivate;
                "Architecture" = $architecture;
                "Path" = ($folder.FullName.ToString());
            }
        }
    }

}

function PrintDetectedEnvironments($VenvOnly = $false)
{
    for ($i = 0; $i -lt $script:PyEnvironments.Count; $i++)
    {
        if ($VenvOnly)
        {
            if ( $script:PyEnvironments[$i]['Type'] -ne "VENV" ) { continue }
        }
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
        Write-Host -NoNewline -ForegroundColor "Yellow" " - $($script:PyEnvironments[$i]['Version'])"
        Write-host -NoNewline -ForegroundColor DarkCyan " - $($script:PyEnvironments[$i]['Architecture'])"
        Write-Host -ForegroundColor Yellow " )"
    }

    Write-Host ""
}

function DisplayChoices()
{
    Clear-Host
    # Reset Prompt back to a simmple Default - needed so the VENV Activate.ps1 works as expected
    function global:prompt {"$((pwd).Path)>"}

    Write-Host "Using Install dir:"  $Env:PYTHON_BASE
    Write-Host "Using  VENV   dir:"  $Env:PYTHON_VENV
    Write-Host ""
    Write-Host "Available Commands:"
    Write-Host "    Set-Python      ->      Displays this menu to select a new Python interpreter/VENV"
    Write-Host "    New-VENV        ->      Creates a new Python VENV"
    Write-Host "    Remove-VENV     ->      Removes a Python VENV"
    Write-Host ""
    Write-Host -ForegroundColor "Green" "Which Python Environment do you want to activate?"
    Write-Host -NoNewline "    D  -   Default           "
    Write-Host -ForegroundColor "Yellow" "( System Default Python )"

    PrintDetectedEnvironments
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
            $script:SelectedPythonEnv = $script:PyEnvironments[$choice - 1]
            $showEnv = $True
            if ($script:SelectedPythonEnv['Type'] -eq "VENV")
            {
                $showEnv = $False
            }
            SetPrompt $script:SelectedPythonEnv['Name'].ToString() $showEnv
            if ($script:SelectedPythonEnv["Type"] -eq "VENV")
            {
                . $script:SelectedPythonEnv["Activate"]
            }

            if ($script:SelectedPythonEnv["Type"] -eq "System")
            {
                $ENV:Path = "$($script:SelectedPythonEnv['Path']);$($script:SelectedPythonEnv['Path'])\Scripts;" + $ENV:Path
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

function New-VENV()
{
    Write-Host "This will create a new VENV using Python Version:" $script:SelectedPythonEnv['Version'] - $script:SelectedPythonEnv['Architecture']
    Write-Host "if this is not the desired python version, type 'N' below to cancel"
    Write-Host "then run Set-Python to choose the desired Python environment before re-running New-VENV"
    Write-Host ""
    $choice = Read-Host "Do you want to continue? (N) to abort/cancel, anything else to continue"
    if ($choice.ToLower() -ne "n")
    {
        
        $loop = $true
        while ($loop)
        {
            Write-Host ""
            $venvName = Read-Host "Please Enter the name of the new VENV"
            $choice = Read-Host "    You Entered: $venvName, Would You Like to Use this Name (Y/N)"
            if ($choice.ToLower() -eq "y") 
            {
                $skipLoop = $false
                foreach ( $environment in $script:PyEnvironments)
                {
                    if ($environment['Name'].ToLower() -eq $venvName)
                    {
                        Write-Host -ForegroundColor Red "A VENV with that name already exists"
                        Write-Host -ForegroundColor Yellow "Please enter a different name"
                        $skipLoop = $true
                    }
                }
                if ($skipLoop -eq $true) { continue }
                $loop = $false
                Write-Host ""
                Write-Host "now setting up VENV: $venvName"
                [int]$baseVersion = ($script:SelectedPythonEnv['Version'].split("."))[0]
                
                if ($baseVersion -eq 3)
                {
                    python -m venv $Env:PYTHON_VENV\$venvName | Out-Null
                }

                if ($baseVersion -eq 2)
                {
                    ## see if virtualenv is installed in this version of python
                    $venvTest = [bool](Get-Command virtualenv -errorAction SilentlyContinue)
                    if ( -not $venvTest)
                    {
                        Write-Host "    VirtualEnv not detected, trying to install it through pip.."
                        pip install virtualenv
                    }

                    virtualenv -p $script:SelectedPythonEnv['Exe'] $Env:PYTHON_VENV\$venvName
                }
                
                #rebuild our cache of the python VENV folders, and rebuilt the menu choices
                $script:VenvFolders = (Get-ChildItem $Env:PYTHON_VENV)
                GetChoices

                Write-Host ""
                Write-Host "New VENV $venvName complete"
                Write-Host -ForegroundColor yellow "run Set-Python to select and activate this new python VENV"
            }
        }
        Write-Host ""
    } else {
        Write-Host "Aborted."
    }
}

function Remove-VENV()
{
    $loop = $true
    while($loop)
    {
        Write-Host "Which VENV would you like to remove?"
        PrintDetectedEnvironments $true
        Write-Host ""
        Write-Host "Press X to cancel"
        $choice =  Read-Host "Choice"
        if ($choice.ToLower() -eq "x") 
        {
            return
        }
        if ($choice -gt 0 -and $choice -le $script:PyEnvironments.Count)
        {
            $envToDelete = $script:PyEnvironments[$choice - 1]
            if ($envToDelete['Name'] -ne $script:SelectedPythonEnv['Name'] -and $envToDelete['Type'] -eq "VENV")
            {
                Write-Host "Now Removing VENV.."
                Remove-Item -Path $envToDelete['Path'] -Recurse -Force
    
                #rebuild our cache of the python VENV folders, and rebuilt the menu choices
                $script:VenvFolders = (Get-ChildItem $Env:PYTHON_VENV)
                GetChoices
                $loop = $false
            } else {
                Write-Host "VENV " $envToDelete['Name'] "Not Deleted"
                Write-Host "Is it currently the selected python environment?"
                Write-Host "did you make a valid selection?"
            }
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
    Write-Host "   PYTHON_VENV should point to the base directory where all your python virtual environments exist/will exist"
    Write-Host ""
}
