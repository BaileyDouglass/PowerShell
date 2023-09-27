Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Graphics Example"
$form.Width = 500
$form.Height = 400

# Create a PictureBox to draw on
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Width = 400
$pictureBox.Height = 300
$pictureBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

# Event Handler to perform drawing
$pictureBox.Add_Paint({
    $graphics = $_.Graphics

    # Draw a line
    $pen = New-Object System.Drawing.Pen -ArgumentList ([System.Drawing.Color]::Black)
    $graphics.DrawLine($pen, 0, 0, 200, 100)

    # Draw a rectangle
    $graphics.DrawRectangle($pen, 50, 50, 100, 50)

    # Draw an ellipse
    $graphics.DrawEllipse($pen, 50, 150, 100, 50)

    # Draw text
    $font = New-Object System.Drawing.Font("Arial", 16)
    $brush = New-Object System.Drawing.SolidBrush -ArgumentList ([System.Drawing.Color]::Blue)
    $graphics.DrawString("Hello World", $font, $brush, 150, 50)
})

$form.Controls.Add($pictureBox)
$form.ShowDialog()
