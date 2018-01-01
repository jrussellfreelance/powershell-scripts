$cmdletsList_SelectedIndexChanged = {
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor
	$selected = $cmdletsList.SelectedIndex
	$cmd = $cmdletsList.Items[$selected].ToString()
	$helpBox.Text = Get-Help $cmd | Out-String
	$detailedHelp.Text = Get-Help $cmd -Detailed | Out-String
	$examplesBox.Text = Get-Help $cmd -Examples | Out-String
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
}

$modulesList_SelectedIndexChanged = {
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor
	$selected = $modulesList.SelectedIndex
	$cmdletsList.Items.Clear()
	$mname = $modulesList.Items[$selected].ToString()
	$commands = Get-Command -Module $mname | Sort-Object Name
	foreach($command in $commands) {
		$cmdletsList.Items.Add($command.Name)
	}
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
}

$MainForm_Load = {
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor
	$modules = Get-Module -ListAvailable | Sort-Object Name
	foreach ($module in $modules) {
		$mname = $module.Name
		$modulesList.Items.Add($mname)
	}
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
}

. (Join-Path $PSScriptRoot 'Powershell-Cmdlet-Explorer.designer.ps1')

$MainForm.ShowDialog()