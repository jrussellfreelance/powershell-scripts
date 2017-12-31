$commandsList_SelectedIndexChanged = {
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor
	$selected = $commandsList.SelectedIndex
	$cmd = $commandsList.Items[$selected].ToString()
	$helpBox.Text = Get-Help $cmd | Out-String
	$detailedHelp.Text = Get-Help $cmd -Detailed | Out-String
	$examplesBox.Text = Get-Help $cmd -Examples | Out-String
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
}

$MainForm_Load = {
	
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor
	$commands = Get-Command | Sort-Object Name
	foreach ($command in $commands) {
		$commandsList.Items.Add($command)
	}
	[System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
	$searchBox_TextChanged = {
		$commandsList.Items.Clear()
		foreach ($item in $commands) {
			if ($searchBox.Text -match $item) {
				$commandsList.Items.Add($item)
			}
		}
	}
}

. (Join-Path $PSScriptRoot 'PowershellHelp.designer.ps1')

$MainForm.ShowDialog()