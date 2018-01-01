[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$MainForm = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.ListBox]$modulesList = $null
[System.Windows.Forms.ListBox]$cmdletsList = $null
[System.Windows.Forms.TabControl]$tabControl1 = $null
[System.Windows.Forms.TabPage]$tabPage1 = $null
[System.Windows.Forms.TextBox]$helpBox = $null
[System.Windows.Forms.TabPage]$tabPage2 = $null
[System.Windows.Forms.TextBox]$detailedHelp = $null
[System.Windows.Forms.TabPage]$tabPage3 = $null
[System.Windows.Forms.TextBox]$examplesBox = $null
[System.Windows.Forms.Button]$button1 = $null
function InitializeComponent
{
[System.Resources.ResXResourceReader]$resources = New-Object -TypeName System.Resources.ResXResourceReader -ArgumentList "$PSScriptRoot\Powershell-Cmdlet-Explorer.resx"
$modulesList = (New-Object -TypeName System.Windows.Forms.ListBox)
$cmdletsList = (New-Object -TypeName System.Windows.Forms.ListBox)
$tabControl1 = (New-Object -TypeName System.Windows.Forms.TabControl)
$tabPage1 = (New-Object -TypeName System.Windows.Forms.TabPage)
$helpBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$tabPage2 = (New-Object -TypeName System.Windows.Forms.TabPage)
$detailedHelp = (New-Object -TypeName System.Windows.Forms.TextBox)
$tabPage3 = (New-Object -TypeName System.Windows.Forms.TabPage)
$examplesBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$tabControl1.SuspendLayout()
$tabPage1.SuspendLayout()
$tabPage2.SuspendLayout()
$tabPage3.SuspendLayout()
$MainForm.SuspendLayout()
#
#modulesList
#
$modulesList.FormattingEnabled = $true
$modulesList.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]13))
$modulesList.Name = 'modulesList'
$modulesList.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]199,[System.Int32]589))
$modulesList.TabIndex = [System.Int32]0
$modulesList.add_SelectedIndexChanged($modulesList_SelectedIndexChanged)
#
#cmdletsList
#
$cmdletsList.FormattingEnabled = $true
$cmdletsList.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]218,[System.Int32]13))
$cmdletsList.Name = 'cmdletsList'
$cmdletsList.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]237,[System.Int32]589))
$cmdletsList.TabIndex = [System.Int32]1
$cmdletsList.add_SelectedIndexChanged($cmdletsList_SelectedIndexChanged)
#
#tabControl1
#
$tabControl1.Controls.Add($tabPage1)
$tabControl1.Controls.Add($tabPage2)
$tabControl1.Controls.Add($tabPage3)
$tabControl1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]461,[System.Int32]12))
$tabControl1.Name = 'tabControl1'
$tabControl1.SelectedIndex = [System.Int32]0
$tabControl1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]857,[System.Int32]590))
$tabControl1.TabIndex = [System.Int32]3
#
#tabPage1
#
$tabPage1.Controls.Add($helpBox)
$tabPage1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]22))
$tabPage1.Name = 'tabPage1'
$tabPage1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]849,[System.Int32]564))
$tabPage1.TabIndex = [System.Int32]0
$tabPage1.Text = 'Main'
$tabPage1.UseVisualStyleBackColor = $true
#
#helpBox
#
$helpBox.AcceptsReturn = $true
$helpBox.AcceptsTab = $true
$helpBox.BackColor = [System.Drawing.SystemColors]::Window
$helpBox.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @('Lucida Console',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$helpBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]5))
$helpBox.Multiline = $true
$helpBox.Name = 'helpBox'
$helpBox.ReadOnly = $true
$helpBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$helpBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]843,[System.Int32]559))
$helpBox.TabIndex = [System.Int32]1
$helpBox.WordWrap = $false
#
#tabPage2
#
$tabPage2.Controls.Add($detailedHelp)
$tabPage2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]22))
$tabPage2.Name = 'tabPage2'
$tabPage2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]849,[System.Int32]564))
$tabPage2.TabIndex = [System.Int32]1
$tabPage2.Text = 'Detailed'
$tabPage2.UseVisualStyleBackColor = $true
#
#detailedHelp
#
$detailedHelp.BackColor = [System.Drawing.SystemColors]::Window
$detailedHelp.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @('Lucida Console',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$detailedHelp.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]7,[System.Int32]7))
$detailedHelp.Multiline = $true
$detailedHelp.Name = 'detailedHelp'
$detailedHelp.ReadOnly = $true
$detailedHelp.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$detailedHelp.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]839,[System.Int32]554))
$detailedHelp.TabIndex = [System.Int32]0
$detailedHelp.WordWrap = $false
#
#tabPage3
#
$tabPage3.Controls.Add($examplesBox)
$tabPage3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]22))
$tabPage3.Name = 'tabPage3'
$tabPage3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]849,[System.Int32]564))
$tabPage3.TabIndex = [System.Int32]2
$tabPage3.Text = 'Examples'
$tabPage3.UseVisualStyleBackColor = $true
#
#examplesBox
#
$examplesBox.BackColor = [System.Drawing.SystemColors]::Window
$examplesBox.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @('Lucida Console',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$examplesBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]4))
$examplesBox.Multiline = $true
$examplesBox.Name = 'examplesBox'
$examplesBox.ReadOnly = $true
$examplesBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
$examplesBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]842,[System.Int32]557))
$examplesBox.TabIndex = [System.Int32]0
$examplesBox.WordWrap = $false
#
#MainForm
#
$MainForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]1330,[System.Int32]616))
$MainForm.Controls.Add($tabControl1)
$MainForm.Controls.Add($cmdletsList)
$MainForm.Controls.Add($modulesList)
$MainForm.Icon = ([System.Drawing.Icon]($resources.GetEnumerator() | Where-Object 'Key' -eq '$this.Icon').Value)
$MainForm.Name = 'MainForm'
$MainForm.Text = 'PowerShell Cmdlet Explorer'
$MainForm.add_Load($MainForm_Load)
$tabControl1.ResumeLayout($false)
$tabPage1.ResumeLayout($false)
$tabPage1.PerformLayout()
$tabPage2.ResumeLayout($false)
$tabPage2.PerformLayout()
$tabPage3.ResumeLayout($false)
$tabPage3.PerformLayout()
$MainForm.ResumeLayout($false)
Add-Member -InputObject $MainForm -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name modulesList -Value $modulesList -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name cmdletsList -Value $cmdletsList -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name tabControl1 -Value $tabControl1 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name tabPage1 -Value $tabPage1 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name helpBox -Value $helpBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name tabPage2 -Value $tabPage2 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name detailedHelp -Value $detailedHelp -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name tabPage3 -Value $tabPage3 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name examplesBox -Value $examplesBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name button1 -Value $button1 -MemberType NoteProperty
}
. InitializeComponent
