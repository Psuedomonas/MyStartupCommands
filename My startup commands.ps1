<# 
Author: Nicholas Zehm

Purpose: Allow user to control when specific processes are and are not running

Credits: Stack overflow users Joey, smo, user4350786, Lynn Crumbling
https://stackoverflow.com/questions/28481811/how-to-correctly-check-if-a-process-is-running-and-stop-it
For example code and info for this script

Dev comments:
1. I am a little unsettled that the full name of the processes is not being used in the example code. There is a name for this programming execution style, which is specific to high level languages. Still, I would prefer to explicitly name the process I want to start and stop.

2. Was going to use radio buttons but they are unnecesarily complicated (for my use case), so will use buttons instead

#>
$global:startLGHUB = $true


## Make dat GUI
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'Activate Background Apps'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true

$btnLGHUB = New-Object System.Windows.Forms.Button
$btnLGHUB.Text = "(Re)-activate LGHUB"
$btnLGHUB.Location  = New-Object System.Drawing.Point(0,10)
$btnLGHUB.AutoSize = $true
$main_form.Controls.Add($btnLGHUB)

$btnExecute = New-Object System.Windows.Forms.Button
$btnExecute.Location = New-Object System.Drawing.Size(0,50)
$btnExecute.Size = New-Object System.Drawing.Size(40,30)
$btnExecute.Text = "Yes"
$main_form.Controls.Add($btnExecute)

# (Re)start processes to enable LGHUB mouse
$btnLGHUB.Add_Click{
	if (Get-Process lghub -ErrorAction SilentlyContinue)
	{
		Stop-Process -Name "lghub" -Force
	}
	if (Get-Process lghub_agent -ErrorAction SilentlyContinue)
	{
		Stop-Process -Name "lghub_agent" -Force
	}
	if (Get-Process lghub_updater -ErrorAction SilentlyContinue)
	{
		Stop-Process -Name "lghub_updater" -Force
	}
	if ($global:startLGHUB) #toggle this button
	{
		Start-Process -FilePath "C:\'Program Files'\LGHUB\lghub_updater.exe"
		Start-Process -FilePath "C:\'Program Files'\LGHUB\lghub_agent.exe"
		Start-Process -FilePath "C:\'Program Files'\LGHUB\lghub.exe"
		$btnLGHUB.Text = "Kill LGHUB stuff"
		$global:startLGHUB = $false
	}
	else
	{
		$btnLGHUB.Text = "(Re)-activate LGHUB"
		$global:startLGHUB = $true
	}
}



<#
## Global Variables
## Hopefully catching won't need globals, a bit of testing will be required to confirm
$global:errorProcessList 
$global:errorOperationList

## Functions to function
function startProcess {
	param( [parameter(Mandatory=$true)] $processName)
	$processList = $processName
	$processList | Start-Process -ErrorAction anError($processList, 'start')
}

function stopProcess {
	param( [parameter(Mandatory=$true)] $processName, $timeout = 5, $beNice = $false)
	$processList = Get-Process $processName -ErrorAction anError($processName, 'stop')
	if ($processList)
	{
		if(!beNice)
		{
			$processList | Stop-Process -Force  
		}
		else
		{
			echo "No!"
			# Try gracefully first
			$processList.CloseMainWindow() | Out-Null

			# Wait until all processes have terminated or until timeout
			for ($i = 0 ; $i -le $timeout; $i ++){
				$AllHaveExited = $True
				$processList | % {
					$process = $_
					If (!$process.HasExited){
						$AllHaveExited = $False
					}                    
				}
				If ($AllHaveExited){
					Return
				}
				sleep 1
			}
        # Else: kill
        $processList | Stop-Process -Force  
		}
	}
		
		
}

function anError {
	param($processName, $processOperation)
	$processOpList = $processOpList + $processOperation
	$processList = $processList + $processName
}
#>
$main_form.ShowDialog()





