Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

$form = New-Object Windows.Forms.Form
$form.Text = "Scatter Plot Example"

$chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 300
$chart.Height = 300

$chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

$series = $chart.Series.Add("scatter")
$series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Point
$series.Points.AddXY(1, 3)
$series.Points.AddXY(2, 1)
$series.Points.AddXY(3, 4)
$series.Points.AddXY(4, 2)

$form.Controls.Add($chart)

$form.ShowDialog()
