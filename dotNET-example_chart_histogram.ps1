Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

$form = New-Object Windows.Forms.Form
$form.Text = "Histogram Example"

$chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 300
$chart.Height = 300

$chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

$series = $chart.Series.Add("histogram")
$series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Column
$series.Points.AddY(3)
$series.Points.AddY(5)
$series.Points.AddY(7)
$series.Points.AddY(2)

$form.Controls.Add($chart)

$form.ShowDialog()
