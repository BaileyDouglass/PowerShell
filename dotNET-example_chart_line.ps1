Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

$chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 500
$chart.Height = 300

$chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

[void]$chart.Series.Add("Data")
$chart.Series["Data"].Points.AddXY(0, 0)
$chart.Series["Data"].Points.AddXY(1, 1)
$chart.Series["Data"].Points.AddXY(2, 4)
$chart.Series["Data"].Points.AddXY(3, 9)

$form = New-Object Windows.Forms.Form
$form.Text = "Line Chart Example"
$form.Width = 600
$form.Height = 400

$form.Controls.Add($chart)

$form.ShowDialog()
