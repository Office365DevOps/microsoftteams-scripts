# 批量设置用户的上级
> 陈希章 2020-2-10

1. 安装AzureAD这个PowerShell模块，请用管理员身份打开PowerShell，然后执行 `Install-Module AzureAD` 命令
1. 请从管理员中心下载用户模板文件，例如当前目录下面这个 `import_user_sample_zh-CHS.csv` 是中文的。请参考这里的帮助 <https://docs.microsoft.com/zh-cn/office365/enterprise/add-several-users-at-the-same-time>
1. 模板中并没有“上级”这个字段，请自行添加并设置
1. 执行 `addusermanager.ps1` 这个脚本，用Office 365的管理员身份登录，可以自动完成所有的上级设置操作
1. 你可以自行修改这个脚本，以符合你的需求。