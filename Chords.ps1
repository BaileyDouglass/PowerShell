# Create a MemoryStream and BinaryWriter to keep data in memory
$ms = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter($ms)

# Function to write a 16-bit integer in Little-Endian format
Function Write-Int16LE {
    param (
        [System.IO.BinaryWriter]$bw,
        [int]$value
    )
    $bytes = [BitConverter]::GetBytes($value)
    $bw.Write($bytes, 0, 2)
}

# Function to write a 32-bit integer in Little-Endian format
Function Write-Int32LE {
    param (
        [System.IO.BinaryWriter]$bw,
        [int]$value
    )
    $bytes = [BitConverter]::GetBytes($value)
    $bw.Write($bytes, 0, 4)
}

# Function to generate audio samples for a given set of Rife frequencies
Function GenerateAudio {
    param (
        $bw,  # BinaryWriter to write audio samples
        $voices,  # Array of voice objects containing Rife frequencies and volume
        $duration  # Duration in seconds
    )
    
    $sampleRate = 44100
    $totalSamples = $sampleRate * $duration

    # Generate each sample
    for ($n = 0; $n -lt $totalSamples; $n++) {
        $sample = 0

        # Generate sample for each voice
        foreach ($voice in $voices) {
            $freq = $voice.Frequency
            $sample += $voice.Volume * [Math]::Sin(2 * [Math]::PI * $freq * $n / $sampleRate)
        }

        # Write the sample to the buffer
        $sample = [Math]::Round($sample * 32767)
        Write-Int16LE $bw ([Math]::Max([Math]::Min($sample, 32767), -32768))  # Clamp to 16-bit range
    }
}

# Frequencies for multiple chords (C Major, G Major, A Minor, E Minor, B Diminished)
$Frequencies = 261.63, 329.63, 391.99, 392.00, 493.88, 587.33, 220.00, 261.63, 329.63, 329.63, 392.00, 493.88, 246.94, 293.66, 347.65
$Volumes = 0.15, 0.3, 0.07

# Initialize voices with Rife frequencies
$voices = @()
1..4 | ForEach-Object {
    $voices += [PSCustomObject]@{
        Frequency = Get-Random -InputObject $Frequencies
        Volume = Get-Random -InputObject $Volumes
    }
}

# Loop for continuous audio stream
While ($true) {
    # Reset MemoryStream
    $ms.SetLength(0)

    # WAV Header
    $bw.Write([Text.Encoding]::UTF8.GetBytes("RIFF"))  # ChunkID
    Write-Int32LE $bw 0  # Placeholder for ChunkSize
    $bw.Write([Text.Encoding]::UTF8.GetBytes("WAVE"))  # Format
    $bw.Write([Text.Encoding]::UTF8.GetBytes("fmt "))  # Subchunk1ID
    Write-Int32LE $bw 16  # Subchunk1Size (16 for PCM)
    Write-Int16LE $bw 1   # AudioFormat (1 for PCM)
    Write-Int16LE $bw 1   # NumChannels
    Write-Int32LE $bw 44100  # SampleRate
    Write-Int32LE $bw 88200  # ByteRate
    Write-Int16LE $bw 2   # BlockAlign
    Write-Int16LE $bw 16  # BitsPerSample
    $bw.Write([Text.Encoding]::UTF8.GetBytes("data"))  # Subchunk2ID
    Write-Int32LE $bw 0  # Placeholder for Subchunk2Size

    # Generate Audio
    GenerateAudio -bw $bw -voices $voices -duration 2

    # Update ChunkSize and Subchunk2Size
    $fileSize = $ms.Position
    $ms.Position = 4
    Write-Int32LE $bw ($fileSize - 8)
    $ms.Position = 40
    Write-Int32LE $bw ($fileSize - 44)

    # Create SoundPlayer object to play the sound
    $soundPlayer = New-Object System.Media.SoundPlayer
    $ms.Position = 0  # Reset MemoryStream position for reading
    $soundPlayer.Stream = $ms
    $soundPlayer.Load()
    $soundPlayer.PlaySync()  # Use PlaySync to wait for completion
}
