# 获取用户的身份，请注意使用管理员账号
$credential = Get-Credential 

# 连接到SharePoint管理中心，请注意先安装 SharePoint Module，参考 https://www.microsoft.com/en-us/download/details.aspx?id=35588
# 这里的Url是SharePoint 管理中心的地址，通常是 https://tenantName-admin.sharepoint.com
Connect-SPOService -Url "https://greatchinaoffice365-admin.sharepoint.com" -Credential $credential
# 连接到Teams
Connect-MicrosoftTeams -Credential $credential
# 获取具体哪个团队的编号
$teamId = "2cefd824-1387-43f3-9177-7f1db4f71dcf"
# 获取该团队中角色为Member的用户
$members = Get-TeamUser -Role Member -GroupId $teamId
foreach ($item in $members) {
    # 这里剔除掉来宾账号，如果之前有把来宾账号提升为Member的话
    if (not $item.User -contains "#EXT#") {
        # 将用户添加到对应的组中去。你需要根据自己的情况修改Site和Group参数的值
        Add-SPOUser -Site "https://greatchinaoffice365.sharepoint.com/sites/MicrosoftTeamsCommunity9" -LoginName $item.User -Group "Microsoft Teams Community Members"
    }
}
# 获取该团队中角色为Owner的用户
$owners = Get-TeamUser -Role Owner -GroupId $teamId

foreach ($item in $owners) {
    # 将用户添加到对应的组中去。你需要根据自己的情况修改Site和Group参数的值
        Add-SPOUser -Site "https://greatchinaoffice365.sharepoint.com/sites/MicrosoftTeamsCommunity9" -LoginName $item.User -Group "Microsoft Teams Community Members"
}

