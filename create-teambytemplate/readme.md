# 通过模板创建团队
> 作者：陈希章 2020-1-26

## 脚本概述

这个脚本包含了一个函数，可以快速创建一个基于模板的团队。

## 如何使用

1. 请先安装Microsoft Teams的Powershell模块（测试版本），关于如何安装，请参考 <https://aka.ms/teamsfriday-4>
1. 下载 `create-teambytemplate.ps1` 和 `template.json` 这两个文件
1. 按照你的需求修改 `template.json` 文件
1. 打开Powershell命令行窗口，导航到以上两个文件保存的目录
1. 执行 `Import-Module ./create-teambytemplate.ps1`
1. 执行类似这样的命令来完成你的操作  `New-TeamByTemplate -title "test template" -description "test template team creation" -owner "ares@greatchinaoffice365.onmicrosoft.com"`

## 使用反馈
1. 你可以发邮件到 teamsfriday@service.microsoft.com 