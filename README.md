# MacScreenshot - 轻量原生Mac截图标注工具

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Language](https://img.shields.io/badge/language-Swift-orange.svg)](https://swift.org/)

> 一款轻量、原生、快速的Mac截图标注工具，专为开发者和内容创作者设计。

## 📖 简介

MacScreenshot 是一个原生的macOS应用程序，专注于提供**快速、简洁、高效**的截图和标注体验。相比于臃肿的第三方截图工具，MacScreenshot 保持轻量，只做核心功能，启动快，不占用系统资源。

## ✨ 核心功能

### 📸 截图功能
- [x] 全屏截图
- [x] 区域截图（拖拽选择）
- [x] 窗口截图（点击选择窗口）
- [x] 延时截图（支持3秒/5秒延时）

### ✏️ 标注功能
- [x] **矩形标注** - 框选重点区域
- [x] **椭圆/圆形标注** - 高亮圆形区域
- [x] **箭头标注** - 指示方向
- [x] **文字标注** - 添加文字说明
- [x] **画笔/手绘** - 自由绘制
- [x] **马赛克/模糊** - 遮挡敏感信息
- [x] **裁剪** - 裁剪截图区域
- [x] **橡皮擦** - 擦除绘制内容

### ⚙️ 辅助功能
- [x] 快捷键支持（全局可自定义）
- [x] 复制到剪贴板
- [x] 保存到文件（支持PNG/JPG）
- [x] 分享到其他应用
- [x] 撤销/重做
- [x] 自动保存到历史记录
- [x] 暗色模式支持

## 🎨 特色

- **原生Swift编写** - 充分利用macOS性能，响应快速
- **轻量无臃肿** - 只保留核心功能，不包含广告和无关功能
- **启动飞快** - 点击快捷键瞬间启动
- **内存占用低** - 常驻内存仅数MB
- **免费开源** - MIT许可证，可自由使用和修改

## 🚀 快速开始

### 系统要求
- macOS 12.0+
- Apple Silicon / Intel 都支持

### 下载安装
1. 从 [Releases](https://github.com/LiangJunChan/mac-screenshot-annotator/releases) 下载最新版本
2. 拖动到`应用程序`文件夹完成安装
3. 首次打开需要在`系统设置 → 隐私与安全性`允许打开

### 构建源码
```bash
git clone git@github.com:LiangJunChan/mac-screenshot-annotator.git
cd mac-screenshot-annotator
open src/MacScreenshot.xcodeproj
# 使用Xcode编译即可
```

## ⌨️ 默认快捷键

| 功能 | 快捷键 |
|------|--------|
| 区域截图 | `Cmd + Shift + A` |
| 全屏截图 | `Cmd + Shift + F` |
| 窗口截图 | `Cmd + Shift + W` |
| 延时截图(3s) | `Cmd + Shift + D` |
| 显示主窗口 | `Cmd + Shift + S` |
| 取消截图 | `Esc` |
| 确认截图 | `Enter` |

> 所有快捷键都可以在偏好设置中自定义。

## 📁 项目结构

```
mac-screenshot-annotator/
├── README.md               # 项目说明
├── LICENSE                 # 许可证
├── CHANGELOG.md            # 更新日志
├── docs/
│   ├── PRD.md              # 产品需求文档
│   ├── DEVELOPMENT.md      # 开发指南
│   └── SCREENS.md         # 截图展示
├── assets/
│   └── AppIcon-Design.md  # App图标设计方案
├── src/
│   ├── MacScreenshot.xcodeproj/      # Xcode项目
│   └── MacScreenshot/                # 应用程序主目标
│       ├── Info.plist                 # 应用信息
│       ├── Sources/                 # 源代码
│       │   ├── AppDelegate.swift
│       │   ├── StatusBarManager.swift
│       │   ├── ScreenshotManager.swift
│       │   ├── CaptureEngine.swift
│       │   ├── AnnotationCanvasViewController.swift
│       │   ├── Tools/                 # 标注工具
│       │   │   ├── AnnotationTool.swift    # 工具协议
│       │   │   ├── RectTool.swift         # 矩形工具
│       │   │   ├── EllipseTool.swift      # 椭圆工具
│       │   │   ├── ArrowTool.swift        # 箭头工具
│       │   │   ├── PenTool.swift         # 画笔工具
│       │   │   ├── TextTool.swift         # 文字工具
│       │   │   └── MosaicTool.swift      # 马赛克工具
│       │   ├── Models/                 # 数据模型
│       │   │   ├── Settings.swift      # 设置模型
│       │   │   └── Annotation.swift    # 标注模型
│       │   ├── UI/                     # 用户界面
│       │   │   ├── PreferencesWindowController.swift  # 偏好设置窗口
│       │   │   └── ColorPicker.swift                 # 颜色选择器
│       │   └── Utils/                  # 工具类
│       │       ├── KeyboardShortcutManager.swift    # 快捷键管理
│       │       └── FileUtils.swift              # 文件工具
│       └── Resources/
│           └── Assets.xcassets/
│               └── AppIcon.appiconset/    # App图标

## 🛠️ 技术栈

- **语言**: Swift 5.x
- **框架**: AppKit (原生macOS)
- **架构**: MVC
- **最低系统要求**: macOS 12.0

## 📝 产品规划

详见 [产品需求文档](./docs/PRD.md)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request!

## 📄 许可证

MIT License - 详见 [LICENSE](./LICENSE)

## 👨‍💻 作者

[LiangJunChan](https://github.com/LiangJunChan)

---

*一款简单好用的Mac截图标注工具 ✨*
