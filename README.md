# Microsoft Teams 开源脚本库
> 陈希章 | 2018-11-19  

## 概述

这是我创建的一个新的开源项目，专门针对Microsoft Teams开发的一些脚本。这些脚本可能是用于辅助功能，也可能是用自动化的方式来进行Teams调用的。脚本类型包括但不限于PowerShell，Python等。

## 自动根据Forms表单的结果，将用户添加到Teams中

这是一个PowerShell脚本，起初是为了解决我自己的需求。我为所有感兴趣加入社区的朋友准备了一个表单 <https://aka.ms/jointeamsdevcommunity> ，用来提交姓名和邮件地址，一开始人不是很多的时候，我是手工添加用户的，但后来越来越多，工作量也比较大，所以我定义了一个脚本，用来自动化根据Forms表单的结果将用户添加到Teams中来。该脚本的详细说明请参考 [AddUsersToTeams.ps1](AddUsersToTeams.ps1) .

> **请注意，该脚本暂时还无法完全实现自动化，必须在某个客户机电脑上面运行，我现在是每天让它运行一次**，我还在研究其他方案，最理想的情况下是每当有一个人填表后，就自动触发一次调用，但目前因为接口的限制还做不到这一点。

下面这个是我的Forms表单范例

![](images/2018-11-19-13-49-31.png)

运行成功后，**你可能需要等待三个小时左右**，相关用户会自动加入到Team里面来（这个时间延迟是后台AAD的账号同步）

![](images/2018-11-19-13-51-51.png)

## Microsoft Teams 社区

欢迎扫描二维码或者点击链接 <https://aka.ms/jointeamsdevcommunity> 加入Microsoft Teams 技术社区

![](images/2018-11-19-13-24-16.png)

