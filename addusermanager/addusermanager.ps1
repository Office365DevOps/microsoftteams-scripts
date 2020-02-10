Connect-AzureAD

Import-Csv .\import_user_sample_zh-CHS.csv | Select-Object -Property 用户名,上级 | ForEach-Object {
    if(-Not [string]::IsNullOrEmpty($_.上级)){
        $user= $_.用户名;
        $manager = $_.上级;
        $managerObj = Get-AzureADUser -ObjectId $manager;
        Set-AzureADUserManager -ObjectId $user -RefObjectId $managerObj.ObjectID;
    }
}

Write-Host "完成"