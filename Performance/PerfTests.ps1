$iterations = 100000

function Get-RunTime()
{
    param (
        [DateTime] $StartDate,
        [DateTime] $EndDate, 
        [bool] $PSTest
    )

    $dateDiff = New-TimeSpan -Start $StartDate -End $EndDate

    if ($PSTest)
    {
        Write-Host "    POWRSH Elapsed Time: $dateDiff"
    } else {
        Write-Host "    DOTNET Elapsed Time: $dateDiff"
    }
}

Write-Host
Write-Host "Test: (POWRSH) Get-Date vs (DOTNET) System.DateTime.Now"
$start = Get-Date
for ($i = 0; $i -lt $iterations; $i++) 
{ 
    $test = $i
    Get-Date | Out-Null
    if ($test % 10000 -eq 0)
    {
        Write-Host $test
    }
}
$stop = Get-Date
Get-Runtime -StartDate $start -EndDate $stop -PSTest $true
$start = Get-Date
for ($i = 0; $i -lt $iterations; $i++) 
{ 
    $test = $i
    [System.DateTime]::Now | Out-Null
    if ($test % 10000 -eq 0)
    {
        Write-Host $test
    }
}
$stop = Get-Date
Get-Runtime -StartDate $start -EndDate $stop -PSTest $false

Write-Host
Write-Host "Test: Dynamic Array Resize"
$start = Get-Date
$arrayTest = @()
for ($i = 0; $i -lt $iterations; $i++) 
{ 
    $arrayTest += $i
    if ($i % 10000 -eq 0)
    {
        Write-Host $i
    }
}
$stop = Get-Date
Get-Runtime -StartDate $start -EndDate $stop -PSTest $false