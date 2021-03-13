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

$images = (Invoke-WebRequest -Uri "https://adoption.microsoft.com/microsoft-teams/custom-backgrounds-gallery/" -UseBasicParsing).Links.href | Where-Object { ($_ -like "https://adoption.azureedge.net/wp-content/custom-backgrounds-gallery*.jpg") -and (-not (Test-Path "$path\$(Split-Path $_ -Leaf)")) } | Select-Object -Unique 

$images | ForEach-Object {
    $fileName = Split-Path $_ -Leaf
    $filePath = "$path\$fileName"
    Invoke-WebRequest -Uri $_ -OutFile $filePath
    GenerateThumbnail -filePath $filePath
}