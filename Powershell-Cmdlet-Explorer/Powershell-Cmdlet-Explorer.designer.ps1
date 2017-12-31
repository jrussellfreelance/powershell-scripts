[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$MainForm = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.ListBox]$modulesList = $null
[System.Windows.Forms.ListBox]$cmdletsList = $null
[System.Windows.Forms.Button]$button1 = $null
function InitializeComponent
{
[System.Resources.ResXResourceReader]$resources = New-Object -TypeName System.Resources.ResXResourceReader -ArgumentList "$PSScriptRoot\Powershell-Cmdlet-Explorer.resx"
$modulesList = (New-Object -TypeName System.Windows.Forms.ListBox)
$cmdletsList = (New-Object -TypeName System.Windows.Forms.ListBox)
$MainForm.SuspendLayout()
#
#modulesList
#
$modulesList.FormattingEnabled = $true
$modulesList.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]13))
$modulesList.Name = 'modulesList'
$modulesList.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]199,[System.Int32]485))
$modulesList.TabIndex = [System.Int32]0
$modulesList.add_SelectedIndexChanged($modulesList_SelectedIndexChanged)
#
#cmdletsList
#
$cmdletsList.FormattingEnabled = $true
$cmdletsList.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]219,[System.Int32]13))
$cmdletsList.Name = 'cmdletsList'
$cmdletsList.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]524,[System.Int32]485))
$cmdletsList.TabIndex = [System.Int32]1
#
#MainForm
#
$MainForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]756,[System.Int32]516))
$MainForm.Controls.Add($cmdletsList)
$MainForm.Controls.Add($modulesList)
$MainForm.Icon = ([System.Drawing.Icon]($resources.GetEnumerator() | Where-Object 'Key' -eq '$this.Icon').Value)
$MainForm.Name = 'MainForm'
$MainForm.Text = 'PowerShell Cmdlet Explorer'
$MainForm.add_Load($MainForm_Load)
$MainForm.ResumeLayout($false)
Add-Member -InputObject $MainForm -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name modulesList -Value $modulesList -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name cmdletsList -Value $cmdletsList -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name button1 -Value $button1 -MemberType NoteProperty
}
. InitializeComponent
