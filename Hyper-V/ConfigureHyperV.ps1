#make sure we are running as admin, if not force it
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if (-not $myWindowsPrincipal.IsInRole($adminRole))
{
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = $MyInvocation.MyCommand.Definition
    $newProcess.Verb = "runas"
    [System.Diagnostics.Process]::Start($newProcess)
    exit
}

import-module hyper-v

#Setup powershell's default error handling
$error.clear()
$ErrorActionPreference = "Stop"

function Write-Title()
{
    Param(
        [Parameter(
            Mandatory = $true, 
            Position=0)]
        [String] $Title
    )
    # figure out our host window dimensions
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    $titleWidth = $Title.Length
    $padLength = ($windowWidth - $titleWidth)/2

    #write the top title decorations
    $menuCharacter = "-"
    for ($i=0; $i -lt $windowWidth; $i++)
    {
        Write-Host -NoNewline -ForegroundColor Green $menuCharacter
    }
    Write-Host
    Write-Host

    # write our title in the center of the screen
    for ($i=0; $i -lt $padLength; $i++)
    {
        Write-Host -NoNewline " "
    }
    Write-Host -NoNewline -ForegroundColor Green $title
    # minus one from $padLength to account for rounding errors
    # this means that it's not exactly in the center - but good enough for our purposes
    for ($i=0; $i -lt ($padLength-1); $i++)
    {
        Write-Host -NoNewline " "
    }
    Write-Host
    Write-Host

    #write the bottom title decorations
    for ($i=0; $i -lt $windowWidth; $i++)
    {
        Write-Host -NoNewline -ForegroundColor Green $menuCharacter
    }
    Write-Host
    Write-Host
}

function MenuLoop
{
    Param(
        [Parameter(Mandatory = $false)]
        [String] $PageTitle,
        [Parameter(Mandatory = $true)]
        [hashtable] $MenuItems,
        [Parameter(Mandatory = $false)]
        [bool] $ClearHost = $true,
        [Parameter(Mandatory = $false)]
        [string] $MenuText = "Choose one of the following options:"
    )

    $selectionError = $false
    While($true)
    {
        if ($ClearHost)
        {
            Clear-Host
            Write-Title $PageTitle
        }
        
        if ($selectionError)
        {
            Write-Host -ForegroundColor Red "Invalid Selection, Try again"
            $selectionError = $false
        }
        Write-Host $MenuText
        Write-Host
        foreach ($key in $MenuItems.Keys)
        {
            Write-Host -NoNewLine -ForegroundColor Green `t $key 
            Write-Host -NoNewline -ForegroundColor Yellow `t $MenuItems[$key]
            Write-Host
        }
        Write-Host
        [string] $selection = Read-Host "Enter Selection"
        if ( [string] $MenuItems.Keys -match $selection -and $selection.Length -gt 0 )
        {
            return $selection
        } else {
            $selectionError = $true
        }
    }
}

function CreateNewVSwitch()
{
    # find all real interfaces for this computer
    $interfaces = Get-NetAdapter | Where-Object {-not ( $_.InterfaceDescription -like "*virtual*" -or $_.InterfaceDescription -like "*tap*" -or $_.InterfaceDescription -like "*bluetooth*" -or $_.Name -like "*network bridge*") }

    Clear-Host
    Write-Title "Create A New VSwitch"

    # choose the type of VSwitch we want to create
    $vSwitchTypes = @{
        "P" = "_P_rivate vSwitch"
        "E" = "_E_xternal vSwitch"
        "I" = "_I_nternal vSwitch"
    }
    [string] $vSwitchChoice = MenuLoop -MenuItems $vSwitchTypes -ClearHost $false -MenuText "Choose the type of vSwitch you want to create:"

    # if we are setting up an external vSwitch, figure out which interface to use
    if ($vSwitchChoice.ToLower() -eq "e")
    {
        $interfaceOptions = @{}
        for ($i=0; $i -lt $interfaces.Count; $i++)
        {
            $interfaceOptions[$i] = $interfaces[$i].Name
        } 
        [int] $vSwitchInterface = MenuLoop -MenuItems $interfaceOptions -ClearHost $false -MenuText "Select the physical interface to use:"
    }

    switch($vSwitchChoice.ToLower())
    {
        "e" { $suggestedSwitchName = "External " + ($interfaceOptions[$vSwitchInterface]) + " Switch" }
        "p" { $suggestedSwitchName = "Private Switch " + (Get-Random -Maximum 1000000) }
        "i" { $suggestedSwitchName = "Internal Switch " + (Get-Random -Maximum 1000000) }
    }
    [string] $vSwitchName = Read-Host "Enter a Name for this vSwitch ($suggestedSwitchName)"
    if ($vSwitchName.Length -eq 0)
    {
        $vSwitchName = $suggestedSwitchName
    }

    Write-Host
    Write-Host "Please Confirm Your Choices:"
    Write-Host -ForegroundColor Yellow "`tvSwitch Type: "$($vSwitchTypes[$vSwitchChoice].ToString().Replace("_",""))
    if ($vSwitchChoice.ToLower() -eq "e")
    {
        Write-Host -ForegroundColor Yellow "`tvSwitch Physical Interface: "$interfaceOptions[$vSwitchInterface]
    }

    Write-Host -ForegroundColor Yellow "`tvSwitch Name: $vSwitchName"
    Write-Host
    $confirmation = Read-Host "Press Y to confirm and continue"
    if ($confirmation.ToLower() -eq "y")
    {
        Write-Host
        Write-Host -ForegroundColor Green "Now Creating vSwitch..."
        # Create our vSwitch
        switch($vSwitchChoice.ToLower())
        {
            "e" { 
                    try { New-VMSwitch -Name $vSwitchName -NetAdapterName ($interfaceOptions[$vSwitchInterface]) -AllowManagementOS $true | Out-Null }
                    catch 
                    { 
                        Write-Host -ForegroundColor Red -BackgroundColor black "!! Errors Encountered !!"
                        Write-Host
                    }
                }   
            "p" { 
                    try {New-VMSwitch -Name $vSwitchName -SwitchType Private | Out-Null }
                    catch 
                    { 
                        Write-Host -ForegroundColor Red -BackgroundColor black "!! Errors Encountered !!"
                        Write-Host
                    }
                }
            "i" { 
                    try { New-VMSwitch -Name $vSwitchName -SwitchType Internal | Out-Null }
                    catch 
                    { 
                        Write-Host -ForegroundColor Red -BackgroundColor black "!! Errors Encountered !!"
                        Write-Host
                    }
                }
        }

        Write-Host "Errors Encountered: "$error.Count
        if ($error.Count -gt 0)
        {
            Write-Host "Encountered The following Errors:"
            foreach ($err in $error)
            {
                Write-Host
                Write-Host $err
                Write-Host `t "Command: " $err.InvocationInfo.MyCommand.Name
                Write-Host `t "Line #: " $err.InvocationInfo.ScriptLineNumber
                Write-Host `t "Line: " $err.InvocationInfo.Line
                Write-Host
            }
        } else {
            if ( (Get-VMSwitch -Name $vSwitchName).count -gt 0)
            {
                Write-Host
                Write-Host -ForegroundColor Green "No Errors Encountered, and confirmed that vSwitch: $vSwitchName was created successfully"
                Write-Host
            } else {
                Write-Host
                Write-Host "No errors encountered, but I can't find the switch that was created."
                Write-Host "Please use the Hyper-V Manager and check to make sure the switch was created properly"
                Write-Host
            }
            
        }
        Read-Host "Press any key to continue"
    } else {
        Write-Host
        Write-Host -ForegroundColor Red "Aborting to Main Menu"
        Read-Host "Press any key to continue..."
    }
}


$mainMenuOptions = @{
    "C" = "_C_reate New VSwitch"
    "Q" = "_Q_uit"
}

while($true)
{
    [string] $mainMenuChoice = MenuLoop -PageTitle "Main Menu" -MenuItems $mainMenuOptions
    switch( $mainMenuChoice.ToLower() )
    {
        "c" { CreateNewVSwitch }
        "q" { Exit }
    }
}

