$stream_reader = New-Object System.IO.StreamReader{.\tags.txt}
$line_number = 1
$multiplier = @{}
while (($current_line = $stream_reader.ReadLine()) -ne $null)
{
    $mainTag = $current_line.Split(',')[0]
    $additionalTags = $current_line.Replace($current_line.Split(',')[0] + ',', "").Replace(',',"`n")
    $mainTagKey = $mainTag.Replace('.','_').Replace('-','_')
    $multiplier += @{
        "TAG_$mainTagKey" = @{
            mainTag = $mainTag
            additionalTags = $additionalTags
        }
    }
    $line_number++
}
$matrix = $multiplier | ConvertTo-Json -Depth 4 -Compress
Write-Host "##vso[task.setvariable variable=multiplier;isOutput=true;]$matrix"