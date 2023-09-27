# Function to create a real-time pie chart form
function Show-RealTimePieChart {
    param (
        [hashtable]$InitialData,
        [scriptblock]$DataUpdateCallback,
        [int]$Width = 400,
        [int]$Height = 400,
        [int]$Interval = 1000
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Windows.Forms.DataVisualization

    # Initialize Form
    $form = New-Object Windows.Forms.Form
    $form.Width = $Width
    $form.Height = $Height

    # Initialize Chart
    $chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
    $chart.Width = $Width - 100
    $chart.Height = $Height - 100

    $chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
    $chart.ChartAreas.Add($chartArea)

    $series = $chart.Series.Add("DataSeries")
    $series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie

    # Update Chart function
    function UpdateChart {
        $DataUpdateCallback.Invoke()

        $series.Points.Clear()
        $i = 0
        $InitialData.GetEnumerator() | Sort-Object Name | ForEach-Object {
            $series.Points.AddY($_.Value)
            $series.Points[$i].LegendText = $_.Name
            $series.Points[$i].Label = "$($_.Name) $($_.Value)"
            $i++
        }
    }

    # Timer for Real-Time Update
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = $Interval

    # Timer Tick Event
    $timer.Add_Tick({
        UpdateChart
    })

    # Start Timer
    $timer.Start()

    # Add Chart to Form
    $form.Controls.Add($chart)

    # Show Form
    $form.ShowDialog()
}

# Sample usage
$taskStatus = @{
    "Completed" = 0
    "Todo" = 0
    "Failed" = 0
    "Inactive" = 0
}

$callback = {
    $task = Get-Random -Minimum 1 -Maximum 5
    switch ($task) {
        1 { $taskStatus["Completed"]++ }
        2 { $taskStatus["Todo"]++ }
        3 { $taskStatus["Failed"]++ }
        4 { $taskStatus["Inactive"]++ }
    }
}

Show-RealTimePieChart -InitialData $taskStatus -DataUpdateCallback $callback
