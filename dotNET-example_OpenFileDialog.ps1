Add-Type -AssemblyName System.Windows.Forms

$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
$openFileDialog.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
$result = $openFileDialog.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $file = $openFileDialog.FileName
    Write-Host "Selected file: $file"
}
