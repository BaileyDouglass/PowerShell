# Add necessary types
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Initialize form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Custom Task Manager'
$form.Size = New-Object System.Drawing.Size(900,500)

# Initialize ComboBox for selecting Context
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(600, 320)
$comboBox.Size = New-Object System.Drawing.Size(120, 30)
$comboBox.Items.Add("Processes")
$comboBox.Items.Add("Tasks")
$comboBox.Items.Add("Services")
$comboBox.SelectedIndex = 0
$comboBox.Add_SelectedIndexChanged({
    RefreshList
})
$form.Controls.Add($comboBox)

# Create a Hashtable to store lists for Processes, Tasks, and Services
$contextLists = @{}

# Initialize TabControl for right panel
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Location = New-Object System.Drawing.Point(420, 10)
$tabControl.Size = New-Object System.Drawing.Size(360, 300)
$form.Controls.Add($tabControl)

# Initialize TabPages
$safeTab = New-Object System.Windows.Forms.TabPage
$safeTab.Text = 'Safe'
$tabControl.Controls.Add($safeTab)

$suspectTab = New-Object System.Windows.Forms.TabPage
$suspectTab.Text = 'Suspect'
$tabControl.Controls.Add($suspectTab)

# Initialize ListBox for displaying 'safe' and 'suspect' processes
$safeList = New-Object System.Windows.Forms.ListBox
$safeList.Size = New-Object System.Drawing.Size(350, 270)
$safeTab.Controls.Add($safeList)

$suspectList = New-Object System.Windows.Forms.ListBox
$suspectList.Size = New-Object System.Drawing.Size(350, 270)
$suspectTab.Controls.Add($suspectList)

# Initialize ListBox for displaying processes
$procList = New-Object System.Windows.Forms.ListBox
$procList.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
$procList.Location = New-Object System.Drawing.Point(10, 10)
$procList.Size = New-Object System.Drawing.Size(360, 300)

$procList.Add_DrawItem({
    param([System.Object]$sender, [System.Windows.Forms.DrawItemEventArgs]$e)
    $e.DrawBackground()
    $font = $e.Font
    $brush = [System.Drawing.Brushes]::Black
    $item = $procList.Items[$e.Index]
    $point = New-Object System.Drawing.PointF($e.Bounds.X, $e.Bounds.Y)
    if ($safeList.Items.Contains($item)) {
        $brush = [System.Drawing.Brushes]::Green
    } elseif ($suspectList.Items.Contains($item)) {
        $brush = [System.Drawing.Brushes]::Orange
    }
    $e.Graphics.DrawString($item, $font, $brush, $point)
})
$form.Controls.Add($procList)

# Initialize Panel for details
$detailPanel = New-Object System.Windows.Forms.Panel
$detailPanel.Location = New-Object System.Drawing.Point(10, 420)
$detailPanel.Size = New-Object System.Drawing.Size(870, 50)
$detailPanel.BackColor = [System.Drawing.Color]::LightGray
$form.Controls.Add($detailPanel)

# Initialize Label for showing selected process details
$detailLabel = New-Object System.Windows.Forms.Label
$detailLabel.Location = New-Object System.Drawing.Point(5, 5)
$detailLabel.Size = New-Object System.Drawing.Size(860, 40)
$detailPanel.Controls.Add($detailLabel)

function RefreshList {
    $context = $comboBox.SelectedItem
    $procList.Items.Clear()
    if ($contextLists.ContainsKey($context)) {
        $procList.Items.AddRange($contextLists[$context])
    } else {
        if ($context -eq "Processes") {
            $items = Get-Process | ForEach-Object { "$($_.Id) $($_.ProcessName)" }
        } elseif ($context -eq "Tasks") {
            $items = Get-ScheduledTask | ForEach-Object { "$($_.TaskPath) $($_.TaskName)" }
        } elseif ($context -eq "Services") {
            $items = Get-Service | ForEach-Object { "$($_.Status) $($_.DisplayName)" }
        }
        $procList.Items.AddRange($items)
        $contextLists[$context] = $items
    }
}

# Initialize Timer for auto-refresh
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 5000 # 5 seconds
$timer.Add_Tick({ RefreshList })
$timer.Start()


# Initialize Button to Mark as Safe
$markSafeBtn = New-Object System.Windows.Forms.Button
$markSafeBtn.Location = New-Object System.Drawing.Point(60, 320)
$markSafeBtn.Size = New-Object System.Drawing.Size(100, 30)
$markSafeBtn.Text = 'Mark Safe'
$markSafeBtn.Add_Click({
    $selected = $procList.SelectedItem
    if ($selected -ne $null) {
        $safeList.Items.Add($selected)
        $procList.Refresh()
    }
})
$form.Controls.Add($markSafeBtn)

# Initialize Button to Mark as Suspect
$markSuspectBtn = New-Object System.Windows.Forms.Button
$markSuspectBtn.Location = New-Object System.Drawing.Point(200, 320)
$markSuspectBtn.Size = New-Object System.Drawing.Size(100, 30)
$markSuspectBtn.Text = 'Mark Suspect'
$markSuspectBtn.Add_Click({
    $selected = $procList.SelectedItem
    if ($selected -ne $null) {
        $suspectList.Items.Add($selected)
        $procList.Refresh()
    }
})
$form.Controls.Add($markSuspectBtn)

# Initialize Button to Remove selected item
$removeBtn = New-Object System.Windows.Forms.Button
$removeBtn.Location = New-Object System.Drawing.Point(340, 320)
$removeBtn.Size = New-Object System.Drawing.Size(100, 30)
$removeBtn.Text = 'Remove'
$removeBtn.Add_Click({
    $selectedTab = $tabControl.SelectedTab.Text
    if ($selectedTab -eq 'Safe') {
        $safeList.Items.Remove($safeList.SelectedItem)
    } elseif ($selectedTab -eq 'Suspect') {
        $suspectList.Items.Remove($suspectList.SelectedItem)
    }
    $procList.Refresh()
})
$form.Controls.Add($removeBtn)

# Initialize Button to Refresh Process List
$refreshBtn = New-Object System.Windows.Forms.Button
$refreshBtn.Location = New-Object System.Drawing.Point(480, 320)
$refreshBtn.Size = New-Object System.Drawing.Size(100, 30)
$refreshBtn.Text = 'Refresh'
$refreshBtn.Add_Click({
    RefreshList
})
$form.Controls.Add($refreshBtn)

# Show Details of Selected Process
$procList.Add_SelectedIndexChanged({
    $selected = $procList.SelectedItem
    $context = $comboBox.SelectedItem
    if ($selected -ne $null) {
        $id = $selected.Split(' ')[0]
        if ($context -eq "Processes") {
            $details = Get-Process -Id $id
            $detailLabel.Text = "Details: CPU - $($details.CPU) Memory - $($details.WorkingSet) Start Time - $($details.StartTime)"
        } elseif ($context -eq "Tasks") {
            # Logic to display details of tasks
            $detailLabel.Text = "Task Details: Currently not implemented"
        } elseif ($context -eq "Services") {
            # Logic to display details of services
            $details = Get-Service | Where-Object {$_.DisplayName -eq $id}
            $detailLabel.Text = "Details: Status - $($details.Status) DisplayName - $($details.DisplayName)"
        }
    }
})
# Populate ListBox with currently running processes
RefreshList

# Display the form
$form.ShowDialog()
