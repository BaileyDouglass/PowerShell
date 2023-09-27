Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class NativeMethods {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern IntPtr GetWindowLong(IntPtr hWnd, int nIndex);
        
        [DllImport("user32.dll")]
        public static extern int SetWindowLong(IntPtr hWnd, int nIndex, IntPtr dwNewLong);
        
        public const int GWL_EXSTYLE = -20;
        public const int WS_EX_LAYERED = 0x80000;
        public const int WS_EX_TRANSPARENT = 0x20;
    }
"@ 

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 500 # 500 milliseconds
$timer.Add_Tick({
    $hwnd = $form.Handle
    $style = [NativeMethods]::GetWindowLong($hwnd, [NativeMethods]::GWL_EXSTYLE)
    $newStyle = [IntPtr] ($style -bor [NativeMethods]::WS_EX_LAYERED -bor [NativeMethods]::WS_EX_TRANSPARENT)
    [NativeMethods]::SetWindowLong($hwnd, [NativeMethods]::GWL_EXSTYLE, $newStyle)
    $timer.Stop()
})

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Transparent Click-Through Overlay"
$form.Width = 500
$form.Height = 500
$form.TopMost = $true
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.BackColor = [System.Drawing.Color]::White
$form.TransparencyKey = [System.Drawing.Color]::White
$form.Add_Shown({ $timer.Start() })
$form.Opacity = 0.5 # Adjust the opacity between 0.0 and 1.0

# Create PictureBox
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Width = 500
$pictureBox.Height = 500
$pictureBox.Image = [System.Drawing.Image]::FromFile("C:\Users\Baile\OneDrive\Pictures\harold.png") # replace this with the path to your image
$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

$form.Controls.Add($pictureBox)

$form.ShowDialog()
