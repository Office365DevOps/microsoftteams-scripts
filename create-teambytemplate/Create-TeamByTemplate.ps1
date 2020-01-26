Import-Module MicrosoftTeams
function New-TeamByTemplate {
    param (
        [string]$template="template.json",
        [string]$title,
        [string]$description,
        [string]$owner
    )
    
    $config = Get-Content $template -Encoding "UTF8" | Out-String | ConvertFrom-Json

    # 连接到Teams
    Connect-MicrosoftTeams -AccountId $owner
    # 创建团队
    $team = New-Team -DisplayName $title -Description $description -Visibility $config.visibility -Owner $owner

    # 添加所有者
    $owners = $config.owner;

    foreach ($user in $owners){
        Add-TeamUser -GroupId $team.GroupId -User $user -Role Owner
    }

    # 添加频道
    $channels = $config.channels;
    foreach($channel in $channels){
        New-TeamChannel -GroupId $team.GroupId -DisplayName $channel.displayName -MembershipType $channel.type

        if($channel.type -eq "private"){
            foreach($user in $channel.users){
                Add-TeamChannelUser -GroupId $team.GroupId -DisplayName $channel.displayName -User $user
            }
            
        }
    }

    # 添加成员
    foreach($user in $config.members){
        Add-TeamUser -GroupId $team.GroupId -User $user
    }

    # 设置团队属性
    Set-Team -GroupId $team.GroupId -AllowAddRemoveApps $config.settings.allowAddRemoveApps -ShowInTeamsSearchAndSuggestions $config.settings.showInTeamsSearchAndSuggestions


    Disconnect-MicrosoftTeams

}


