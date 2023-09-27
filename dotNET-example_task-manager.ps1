# Add necessary types
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Initialize form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Custom Task Manager'
$form.Size = New-Object System.Drawing.Size(400,400)

# Initialize ListBox for displaying processes
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10, 10)
$listBox.Size = New-Object System.Drawing.Size(360, 300)
$form.Controls.Add($listBox)

# Function to refresh process list
function RefreshProcessList {
    $listBox.Items.Clear()
    $processes = Get-Process
    $processes | ForEach-Object {
        $listBox.Items.Add($_.Id.ToString() + " " + $_.ProcessName)
    }
}

# Initialize button to kill process
$killButton = New-Object System.Windows.Forms.Button
$killButton.Location = New-Object System.Drawing.Point(10, 320)
$killButton.Size = New-Object System.Drawing.Size(100, 30)
$killButton.Text = 'Kill Process'
$killButton.Add_Click({
    $selected = $listBox.SelectedItem
    if ($selected -ne $null) {
        $processId = $selected.Split(' ')[0]
        Stop-Process -Id $processId -Force
        RefreshProcessList
    }
})
$form.Controls.Add($killButton)

# Initialize button to refresh process list
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Location = New-Object System.Drawing.Point(270, 320)
$refreshButton.Size = New-Object System.Drawing.Size(100, 30)
$refreshButton.Text = 'Refresh'
$refreshButton.Add_Click({
    RefreshProcessList
})
$form.Controls.Add($refreshButton)

# Populate ListBox with currently running processes
RefreshProcessList

# Display the form
$form.ShowDialog()
