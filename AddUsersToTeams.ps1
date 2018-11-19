# 自动根据一个调查表来创建Microsoft Teams成员（同时支持内部和外部用户）
# 作者：陈希章
# 时间：2018年11月

# 先决条件，请先在当前计算机安装如下PowerShell模块
# Install-Module ImportExcel -scope CurrentUser
# Install-Module -Name MicrosoftTeams
# Install-Module AzureAD


<#
.SYNOPSIS
获取用户名

.DESCRIPTION
根据Teams中特定的邮箱，解析出来真正的用户名。这里主要是要解决外部用户的问题。

.PARAMETER user
传入的用户名

.EXAMPLE
外部用户在Teams中的用户名通常是这样的 code365_xizhang.com#EXT#@microsoft.onmicrosoft.com

.NOTES
该函数不需要手工调用
#>
function getUserName {
    param(
        [string]$user = ""
    )

    process {
        #外部用户的邮箱显示会带有一个#,类似于 code365_xizhang.com#EXT#@microsoft.onmicrosoft.com
        if ($user.Contains('#')) {
            $temp = $user.Substring(0, $user.IndexOf('#'))
            $index = $temp.LastIndexOf('_')
            $temp = $temp.Remove($index, 1)
            $temp = $temp.Insert($index, '@')
            Write-Output $temp
        }
        else {
            Write-Output $user
        }

    }

}

# 这是Forms表单对应生成的一个Excel文件，这个文件通常是在你的OneDrive for Business的目录中。
$file = "xxxx.xlsx"

# 读取Forms信息，这里假设你的表单有两个字段，分别是“你的姓名”和“你的邮箱”
$items = Import-Excel $file -WorksheetName "Form1" | Where-Object {$_.email -ne $null} | Select-Object -Property @{N = ‘Email'; E = {$_.你的邮箱}}, @{N = 'Name'; E = {$_.你的姓名}}


# 这是当前Microsoft Teams社区的编号（Modern Group id），这个编号可以通过下面的步骤得到
# Connect-MicrosoftTeams
# Get-Team 找到你的Team，复制它的编号，填写在下方
$team = "你的Team编号"

# 这是当前用户的凭据
$credential = Get-Credential

# 连接到Azure AD
Connect-AzureAD -Credential $credential

# 连接到Teams
Connect-MicrosoftTeams -Credential $credential

# 获取现有的成员列表
$users = Get-TeamUser -GroupId $team | Select-Object -Property @{N = 'Email'; E = {getUserName -user $_.User}}

# 比对结果集，确定哪些用户是需要真正添加的
$result = $items | Where-Object {$users.Email -inotcontains $_.Email}

# 循环添加用户
foreach ($item in $result) {

    # 如果是外部用户，你需要先邀请他们作为来宾加入到你的组织
    if (!$item.Name.EndsWith($credential.UserName.Substring($credential.UserName.LastIndexOf('@')))) {

        # 这里发送邀请，设置Display Name
        New-AzureADMSInvitation -InvitedUserEmailAddress $item.Email -InvitedUserDisplayName $item.Name -InviteRedirectURL https://teams.microsoft.com/ -SendInvitationMessage $true

    }

    # 将用户添加到Team
    Add-TeamUser -GroupId $team -User $item.Email -ErrorAction SilentlyContinue
    Write-Host $i.Email
}

