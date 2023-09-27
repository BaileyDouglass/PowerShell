Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

$form = New-Object Windows.Forms.Form
$form.Text = "Area Chart Example"

$chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 300
$chart.Height = 300

$chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

$series = $chart.Series.Add("area")
$series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Area
$series.Points.AddXY(0, 0)
$series.Points.AddXY(1, 2)
$series.Points.AddXY(2, 1)
$series.Points.AddXY(3, 4)

$form.Controls.Add($chart)

$form.ShowDialog()
