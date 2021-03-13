# Microsoft Teams 开源脚本库

> 陈希章 | 2018-11-19

## 概述

这是我创建的一个新的开源项目，专门针对 Microsoft Teams 开发的一些脚本。这些脚本可能是用于辅助功能，也可能是用自动化的方式来进行 Teams 调用的。脚本类型包括但不限于 PowerShell，Python 等。

## 批量下载 Teams 会议背景图片

> 2021-3-13 陈希章

打开本地的 PowerShell，运行这一行代码即可 `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Office365DevOps/microsoftteams-scripts/master/downloadmeetingbackgrounds.ps1'))`
