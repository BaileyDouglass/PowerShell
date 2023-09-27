# Modified Get-AllServices.ps1

# Fetch all services on the machine
$allServices = Get-Service

# Initialize an empty array to hold service information
$serviceInfoArray = @()

# Iterate through each service
foreach ($service in $allServices) {
    # Create a custom object to hold relevant information
    $serviceInfo = [PSCustomObject]@{
        'ServiceName'          = $service.ServiceName
        'DisplayName'          = $service.DisplayName
        'Status'               = $service.Status
        'CanPauseAndContinue'  = $service.CanPauseAndContinue
        'CanShutdown'          = $service.CanShutdown
        'CanStop'              = $service.CanStop
        'ServiceType'          = $service.ServiceType
        'StartType'            = $service.StartType
    }

    # Add the custom object to the array
    $serviceInfoArray += $serviceInfo
}

# Output the service information as a table
$serviceInfoArray | Sort-Object CanStop | Format-Table -AutoSize ServiceName, DisplayName, Status, CanPauseAndContinue, CanShutdown, CanStop, ServiceType, StartType
