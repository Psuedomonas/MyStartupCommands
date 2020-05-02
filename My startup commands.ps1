<# 
Author: Nicholas Zehm
Date: 5/2/20
Purpose: Allow user to control when specific processes are and are not running
#>

#global button toggle
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
		Start-Process -FilePath "C:\Program Files\LGHUB\lghub_updater.exe"
		Start-Process -FilePath "C:\Program Files\LGHUB\lghub_agent.exe"
		Start-Process -FilePath "C:\Program Files\LGHUB\lghub.exe"
		$btnLGHUB.Text = "Kill LGHUB stuff"
		$global:startLGHUB = $false
	}
	else
	{
		$btnLGHUB.Text = "(Re)-activate LGHUB"
		$global:startLGHUB = $true
	}
}

$main_form.ShowDialog()





