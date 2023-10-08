Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

class Node {
    [int]$X
    [int]$Y
    [System.Drawing.Color]$Color
    [string]$Status
    [string]$Label

    Node ([int]$x, [int]$y, [string]$status, [string]$label) {
        $this.X = $x
        $this.Y = $y
        $this.Status = $status
        $this.Label = $label
        $this.SetColorBasedOnStatus()
    }

    [void]SetColorBasedOnStatus() {
        switch ($this.Status) {
            'Active' { $this.Color = [System.Drawing.Color]::Green }
            'Inactive' { $this.Color = [System.Drawing.Color]::Red }
            'Pending' { $this.Color = [System.Drawing.Color]::Yellow }
            default { $this.Color = [System.Drawing.Color]::Gray }
        }
    }

    [void]Draw([System.Drawing.Graphics]$graphics) {
        $brush = [System.Drawing.SolidBrush]::new($this.Color)
        $graphics.FillEllipse($brush, $this.X, $this.Y, 20, 20)
    }

    [void]DrawMetadata([System.Drawing.Graphics]$graphics) {
        $font = New-Object System.Drawing.Font("Segoe UI Emoji", 12)
        $emoji = [char]::ConvertFromUtf32(0x1F643)  # 😀
        $graphics.DrawString($($this.Label + ' ' + $emoji), $font, [System.Drawing.Brushes]::Black, ($this.X + 25), ($this.Y + 5))
        # Add additional metadata here as needed.
    }
}

# Initialize Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Main Window"
$form.Size = New-Object System.Drawing.Size(800,600)

# Initialize PictureBox
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::AutoSize

# Initialize Bitmap and Graphics objects
$bitmap = New-Object System.Drawing.Bitmap $form.Width, $form.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Initialize variables
$script:random = New-Object System.Random
$script:nodeCount = 50
$script:nodes = @()
$script:statuses = @('Active', 'Inactive', 'Pending')
$script:selectedNode = $null

# Function to draw all nodes
function DrawNodes {
    $graphics.Clear([System.Drawing.Color]::White)

    #Draw the nodes first
    foreach ($node in $script:nodes) {
        $node.Draw($graphics)
    }

    # Overlay metadata
    foreach ($node in $script:nodes) {
        $node.DrawMetadata($graphics)
    }

    $pictureBox.Image = $bitmap
    $pictureBox.Refresh()
}

# Create nodes with random positions, statuses, and labels
for ($i = 0; $i -lt $script:nodeCount; $i++) {
    $x = $script:random.Next(0, $form.Width)
    $y = $script:random.Next(0, $form.Height)
    $status = $script:statuses | Get-Random
    $label = "Node" + ($i + 1)
    $node = [Node]::new($x, $y, $status, $label)
    $script:nodes += $node
}

DrawNodes
$form.Controls.Add($pictureBox)

# Select node on mouse down and prepare for drag
$pictureBox.Add_MouseDown({
    Write-Host "Mouse button pressed"
    $mousePos = $form.PointToClient([System.Windows.Forms.Control]::MousePosition)
    $script:selectedNode = $null
    foreach ($node in $script:nodes) {
        if (($mousePos.X - $node.X) -lt 20 -and ($mousePos.X - $node.X) -gt 0 -and ($mousePos.Y - $node.Y) -lt 20 -and ($mousePos.Y - $node.Y) -gt 0) {
            $script:selectedNode = $node
            Write-Host "Node selected"
            break
        }
    }
})


# Update node position while dragging
$pictureBox.Add_MouseMove({
    if ($null -ne $script:selectedNode) {
        $mousePos = $form.PointToClient([System.Windows.Forms.Control]::MousePosition)
        $script:selectedNode.X = $mousePos.X - 10
        $script:selectedNode.Y = $mousePos.Y - 10
        DrawNodes
    }
})

# Deselect node on mouse up
$pictureBox.Add_MouseUp({
    Write-Host "Mouse button released"
    $script:selectedNode = $null
})


# Show Form
$form.ShowDialog()
