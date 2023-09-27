# Add required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

# Initialize form
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(600,400)
$form.Text = "PowerShell .NET Graph Example"

# Initialize chart
$chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 500
$chart.Height = 300
$chartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

# Generate example data and add to chart
[void]$chart.Series.Add("Data")
$chart.Series["Data"].Points.AddXY("Jan", 200)
$chart.Series["Data"].Points.AddXY("Feb", 180)
$chart.Series["Data"].Points.AddXY("Mar", 210)
$chart.Series["Data"].Points.AddXY("Apr", 150)

# Initialize button to refresh data
$button = New-Object System.Windows.Forms.Button
$button.Text = "Refresh"
$button.Top = 320
$button.Left = 260

$button.Add_Click({
    $chart.Series["Data"].Points.Clear()
    $chart.Series["Data"].Points.AddXY("Jan", (Get-Random -Minimum 100 -Maximum 300))
    $chart.Series["Data"].Points.AddXY("Feb", (Get-Random -Minimum 100 -Maximum 300))
    $chart.Series["Data"].Points.AddXY("Mar", (Get-Random -Minimum 100 -Maximum 300))
    $chart.Series["Data"].Points.AddXY("Apr", (Get-Random -Minimum 100 -Maximum 300))
})

# Add controls to form
$form.Controls.Add($chart)
$form.Controls.Add($button)

# Show form
$form.ShowDialog()
