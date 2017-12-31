$modulesList_SelectedIndexChanged = {
	$selected = $modulesList.SelectedIndex
	$cmdletsList.Items.Clear()
	$mname = $modulesList.Items[$selected].ToString()
	$commands = Get-Command -Module $mname
	foreach($command in $commands) {
		$cmdletsList.Items.Add($command.Name)
	}
}

$MainForm_Load = {
	$modules = Get-Module -ListAvailable
	foreach ($module in $modules) {
		$mname = $module.Name
		$modulesList.Items.Add($mname)
	}
}

. (Join-Path $PSScriptRoot 'Powershell-Cmdlet-Explorer.designer.ps1')

$MainForm.ShowDialog()