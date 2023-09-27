Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Transparent Window"
$form.Width = 300
$form.Height = 300
$form.TopMost = $true
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.ShowInTaskbar = $false
$form.BackColor = [System.Drawing.Color]::White
$form.TransparencyKey = [System.Drawing.Color]::White
$form.Opacity = 0.8 # Optional, to make it semi-transparent

# Allow form to be clicked through
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class ExtendedForm : System.Windows.Forms.Form {
        protected override CreateParams CreateParams {
            get {
                CreateParams cp = base.CreateParams;
                cp.ExStyle |= 0x00000020; // WS_EX_TRANSPARENT
                return cp;
            }
        }
    }
"@
$form = New-Object ExtendedForm

# Load and add image to PictureBox
$imagePath = "C:\Users\Baile\OneDrive\Pictures\cube.png" # Change this path to your image
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Image = [System.Drawing.Image]::FromFile($imagePath)
$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$pictureBox.Dock = [System.Windows.Forms.DockStyle]::Fill

$form.Controls.Add($pictureBox)

$form.ShowDialog()
