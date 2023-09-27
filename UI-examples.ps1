# Message Box
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show('Hello, World!', 'My Dialog Box')

# Input Box
Add-Type -AssemblyName Microsoft.VisualBasic
$UserInput = [Microsoft.VisualBasic.Interaction]::InputBox('Enter your name', 'Name', '')

# File and Folder Dialogs, Swap "Open" for "Save"
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.ShowDialog() | Out-Null
$OpenFileDialog.FileName

# Console-based Menus
$selection = Get-Process | Out-GridView -Title 'Select a process' -PassThru
$selection

# Windows Forms
Add-Type -AssemblyName System.Windows.Forms
$Form = New-Object System.Windows.Forms.Form
$Button = New-Object System.Windows.Forms.Button
$Button.Text = 'Click Me'
$Button.Add_Click({ $Form.Text = 'Hello, World!' })
$Form.Controls.Add($Button)
$Form.ShowDialog()

# Show-Command
Show-Command Get-Process

# Out-GridView
Get-Process | Out-GridView

