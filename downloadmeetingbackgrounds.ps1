# 批量下载可用于Teams会议视频背景的图片
# 作者：陈希章 2021-3-13


function GetEncoder() {
    $format = [Drawing.Imaging.ImageFormat]::Jpeg

    $codecs = [System.Drawing.Imaging.ImageCodecInfo]::GetImageDecoders()
    foreach ($codec in $codecs) {
        if ($codec.FormatID -eq $format.Guid) {
            return $codec;
        }
    }
    return $null;
}


function GenerateThumbnail {
    param (
        [string]$filePath
    )
    $fileName = Split-Path $filePath -Leaf
    $thumbName = "$($fileName.Split('.')[0])_thumb.jpg"
    
    $full = [System.Drawing.Image]::FromFile($filePath);
    $thumb = $full.GetThumbnailImage(280, 158, $null, [System.IntPtr]::Zero);

    $encoder = GetEncoder

    $myEncoder = [Drawing.Imaging.Encoder]::Quality
    $myEncoderParameters = New-Object Drawing.Imaging.EncoderParameters(1)
    $myEncoderParameter = New-Object Drawing.Imaging.EncoderParameter($myEncoder, 24L)
    $myEncoderParameters.Param[0] = $myEncoderParameter

    $thumb.Save($filePath.replace($fileName, $thumbName), $encoder, $myEncoderParameters);
    $full.Dispose();
    $thumb.Dispose();
}




$path = "$home\AppData\Roaming\Microsoft\Teams\Backgrounds\uploads"

if (-not (Test-Path $path)) {
    New-Item $path -ItemType Directory | Out-Null
}

# UseBasicparsing 可以提高性能，而且避免弹出一个对话框的问题，因为它不会尝试用IE去解析文档。（使用老版本的PowerShell的话）
$images = (Invoke-WebRequest -Uri "https://adoption.microsoft.com/microsoft-teams/custom-backgrounds-gallery/" -UseBasicParsing).Links.href | Where-Object { ($_ -like "https://adoption.azureedge.net/wp-content/custom-backgrounds-gallery*.jpg") -and (-not (Test-Path "$path\$(Split-Path $_ -Leaf)")) } | Select-Object -Unique 

$wc = New-Object System.Net.WebClient
$index = 1
$count = $images.Count

$images | ForEach-Object {
    
    $fileName = Split-Path $_ -Leaf
    $filePath = "$path\$fileName"
    # 使用web client可以明显提高性能
    $wc.DownloadFile($_, $filePath) 
    Write-Progress -Activity "Download Background image" -Status "Save file: $_" -PercentComplete ($index / $count * 100)

    # Invoke-WebRequest -Uri $_ -OutFile $filePath 
    GenerateThumbnail -filePath $filePath

    Write-Progress -Activity "Download Background image" -Status "Generate thumbnail: $fileName" -PercentComplete ($index / $count * 100)

    $index = $index + 1
}