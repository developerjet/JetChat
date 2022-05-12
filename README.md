<div align=center><img src="ScreenShot/JetChatSmall.png" width="934" height="168" /></div>

# JetChat
Swift5.0编写的简仿微信聊天应用，完美支持表情键盘、单聊、群聊、本地消息会话缓存、朋友圈、白天和黑夜主题模式<br>
 
[![platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=plastic)](#)
[![languages](https://img.shields.io/badge/language-swift-blue.svg)](#) 
[![support](https://img.shields.io/badge/support-ios%208%2B-orange.svg)](#) 

 ### Examples
| 聊天 | 朋友圈 |
| -- | -- |
|![image](https://github.com/developerjet/JetChat/blob/master/ScreenShot/JetChat.gif)|![image](https://github.com/developerjet/JetChat/blob/master/ScreenShot/Moments.png)|

| 夜间模式 | 白天模式 |
| -- | -- |
|![image](https://github.com/developerjet/JetChat/blob/master/ScreenShot/DarkTheme.png)|![image](https://github.com/developerjet/JetChat/blob/master/ScreenShot/LightTheme.png)|

### 主要技术运用
- 聊天功能采用RxSwift+MVVM响应式架构设计，通过ViewModel合理过渡处理消息数据，减轻Controller层业务计算
- UITableView+FDTemplateLayoutCell实现cell高度自适应计算和缓存，提高列表滑动顺滑
- WCDBSwift实现所有会话消息快速缓存
- 基于IGList数据驱动，实现高帧率朋友圈列表滑动
- RxTheme适配夜间模式并兼容iOS13跟随系统模式设置
- SnapKit纯代码自动布局
- 后续开发完善中.....

### 主要实现功能
- 聊天室键盘控件封装处理，支持表情文字多行输入，支持iOS13
- 用户：添加好友，添加群，用户备注名称修改，本地实时同步
- 聊天：一对一单聊，一对多群聊，支持文字、视频、图片发送和转发，图片和视频浏览
- 会话：最近聊天会话记录，并按照最近时间排序列表展示
- 角标：单个会话未读消息数量展示，全部未读消息数量显示
- 清除：单个消息删除，退出群，删除好友，消息会话角标清除，记录删除

> 具体功能了解可以下载源码运行查看 https://github.com/developerjet/JetChat

### 新增功能
- 朋友圈：通过IGList实现高帧率朋友圈列表滑动
- 黑夜模式：通过RxTheme实现白天和黑夜主题模式切换并兼容iOS13跟随系统模式设置
- 多语言切换：已新增简体中文、英文翻译
- Widget：新增最近聊天小组件，Widget点击跳转聊天室

### Tips
- 如果你有更好的建议和方案请在lssues提交

### Licensed under the [MIT licens](https://github.com/developerjet/JetChat/blob/master/LICENSE)
- 如果你对该项目感兴趣或者对你有一些帮助，希望可以给我点个🌟Star🌟，非常感谢<br>
