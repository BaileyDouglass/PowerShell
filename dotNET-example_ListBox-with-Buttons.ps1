Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(300,200)
$form.Text = "List Box Example"

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,10)
$listBox.Size = New-Object System.Drawing.Size(200,100)
$listBox.Items.AddRange(@("Item 1", "Item 2", "Item 3"))

$buttonAdd = New-Object System.Windows.Forms.Button
$buttonAdd.Location = New-Object System.Drawing.Point(220,10)
$buttonAdd.Size = New-Object System.Drawing.Size(60,30)
$buttonAdd.Text = "Add"
$buttonAdd.Add_Click({
    $listBox.Items.Add("New Item")
})

$buttonRemove = New-Object System.Windows.Forms.Button
$buttonRemove.Location = New-Object System.Drawing.Point(220,50)
$buttonRemove.Size = New-Object System.Drawing.Size(60,30)
$buttonRemove.Text = "Remove"
$buttonRemove.Add_Click({
    $item = $listBox.SelectedItem
    if ($item) {
        $listBox.Items.Remove($item)
    }
})

$form.Controls.AddRange(@($listBox, $buttonAdd, $buttonRemove))
$form.ShowDialog()
