$iterations = 100000

function Get-RunTime()
{
    param (
        [DateTime] $StartDate,
        [DateTime] $EndDate
    )

    $dateDiff = New-TimeSpan -Start $StartDate -End $EndDate
    $dateString = "    Elapsed Time (d:h:m:s.ms): {0}:{1}:{2}:{3}.{4}" -f $dateDiff.Days,$dateDiff.Hours,$dateDiff.Minutes, $dateDiff.Seconds, $dateDiff.Milliseconds
    Write-Host $dateString
}

Write-Host
Write-Host "Test: PowerShell Get-Date Loop"
$start = [System.DateTime]::Now
for ($i = 0; $i -lt $iterations; $i++) 
{ 
    $test = $i
    Get-Date | Out-Null
    if ($test % 10000 -eq 0)
    {
        Write-Host $test
    }
}
$stop = [System.DateTime]::Now
Get-Runtime -StartDate $start -EndDate $stop

Write-Host
Write-Host "Test: System.DateTime.Now Loop"
$start = [System.DateTime]::Now
for ($i = 0; $i -lt $iterations; $i++) 
{ 
    $test = $i
    [System.DateTime]::Now | Out-Null
    if ($test % 10000 -eq 0)
    {
        Write-Host $test
    }
}
$stop = [System.DateTime]::Now
Get-Runtime -StartDate $start -EndDate $stop

Write-Host
Write-Host "Test: Dynamic Array Resize - DotNet"
$start = [System.DateTime]::Now
$arrayTest = New-Object System.Collections.Generic.List[int]
for ($i = 0; $i -lt $iterations; $i++) 
{ 
    $arrayTest.add($i)
    if ($i % 10000 -eq 0)
    {
        Write-Host $i
    }
}
$stop = [System.DateTime]::Now
Get-Runtime -StartDate $start -EndDate $stop

$skip = $true
if (-not $skip)
{
    Write-Host
    Write-Host "Test: Dynamic Array Resize - PowerShell"
    $start = [System.DateTime]::Now
    $arrayTest = @()
    for ($i = 0; $i -lt $iterations; $i++) 
    { 
        $arrayTest += $i
        if ($i % 10000 -eq 0)
        {
            Write-Host $i
        }
    }
    $stop = [System.DateTime]::Now
    Get-Runtime -StartDate $start -EndDate $stop
}

Write-Host
Write-Host "Test: Find Primes - Brute Force"
$start = [System.DateTime]::Now
$primeCount = 0
for ($i = 2; $i -lt $iterations; $i++) 
{ 
    $primeTest = 0
    for ($n = 2; $n -lt $i; $n++)
    {
        if ( ($i % $n) -eq 0)
        {
            $primeTest += 1
            break
        }
    }
    if ($primeTest -eq 0)
    {
        $primeCount += 1
    }
}
$stop = [System.DateTime]::Now
Write-Host "Found $primeCount prime numbers less than $iterations"
Get-Runtime -StartDate $start -EndDate $stop