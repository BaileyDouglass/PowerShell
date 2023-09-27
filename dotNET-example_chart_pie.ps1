Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

$form = New-Object Windows.Forms.Form
$form.Text = "Pie Chart Example"

$chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 300
$chart.Height = 300

$chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

$series = $chart.Series.Add("pie")
$series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie
$series.Points.AddY(40)
$series.Points.AddY(30)
$series.Points.AddY(20)
$series.Points.AddY(10)

$form.Controls.Add($chart)

$form.ShowDialog()
