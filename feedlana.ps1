# feedlana.ps1 - Prevent RSI injury and level up your companion
param(
	[int]$StackSize = $(Read-Host "Enter the stack size"),
	[int]$LegacyLevel = $(Read-Host "Enter your legacy of Promptness level [0-3]"),
	[string]$HotKey = $(Read-Host "Enter the gift hotkey [1..=]"),
	[switch]$Quiet,
	[switch]$SpeedRun
)
# Customizable variables

# Size of stack
$stack = $StackSize
# Speed of give
$givespeed = 0
Switch ($LegacyLevel) {  # Legacy of Altruism level
	0  {$givespeed = 3000}  # none
	1  {$givespeed = 2400}  # Rank I
	2  {$givespeed = 2100}  # Rank II
	3  {$givespeed = 1750}  # Rank III
	default  {$givespeed = 3000}
}

##########
# Sleep function
Function GoToSleep {
	param(
		[int]$milliseconds = 1000,
		[switch]$PlusRandomWait
	)
	$sleeptime = $milliseconds

	if ($PlusRandomWait) {
		$randomwait = get-random -Minimum 1 -Maximum 200
		if ($randomwait -lt 10) {
			$sleeptime += (get-random -Minimum 1 -Maximum 4) * 1000
		}
		if ($randomwait -lt 3) {
			$sleeptime += (get-random -Minimum 3 -Maximum 13) * 1000
		}
		if ($randomwait -eq 1) {
			$sleeptime += (get-random -Minimum 7 -Maximum 20) * 1000
		}
	}

	Write-Debug "Sleeping $sleeptime"
	Start-Sleep -Milliseconds $sleeptime

}


##########
# Main loop

if (-not $Quiet) {
#	Write-Host "Feeding Lana"
#	Write-Host "Stacksize: $StackSize"
#	Write-Host "Legacy level: $LegacyLevel"
#	Write-Host "HotKey: $HotKey"
#	Write-Host "Estimated time of completion: $((get-date).AddMilliseconds($StackSize * $givespeed))"
}
$done = $false
$i = 1

[void] [System.Reflection.Assembly]::LoadWithPartialName("'System.Windows.Forms")

while (-not $done) {
	
	if ($SpeedRun) {
		GoToSleep -milliseconds $givespeed
	} else {
		GoToSleep -milliseconds $givespeed -PlusRandomWait
	}

	[System.Windows.Forms.SendKeys]::SendWait($HotKey)
	
	if (-not $Quiet) {
		#Write-Host "`r$($stack - $i + 1)" -NoNewline
		Write-Progress -Activity "Feeding Lana - Stacksize: $StackSize - time of completion: $((get-date).AddMilliseconds(($StackSize - $i)* $givespeed))" -Status "Percent complete" -PercentComplete $($i/$stack*100)
	}

	$i++
	if ($i -gt $stack) { $done = $true }

}
