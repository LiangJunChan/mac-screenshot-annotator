# 开发指南 - MacScreenshot

## 📋 目录
- [1. 环境准备](#1-环境准备)
- [2. 项目结构](#2-项目结构)
- [3. 编译运行](#3-编译运行)
- [4. 代码架构](#4-代码架构)
- [5. 开发规范](#5-开发规范)
- [6. 提交贡献](#6-提交贡献)
- [7. 发布流程](#7-发布流程)

---

## 1. 环境准备

### 1.1 系统要求
- macOS 12.0+
- Xcode 14.0+
- Swift 5.7+

### 1.2 安装依赖
项目没有第三方依赖，全部使用原生框架，无需额外安装依赖。

```bash
# 克隆项目
git clone https://github.com/LiangJunChan/mac-screenshot-annotator.git
cd mac-screenshot-annotator

# 打开Xcode项目
open src/MacScreenshot.xcodeproj
```

---

## 2. 项目结构

```
mac-screenshot-annotator/
├── README.md                    # 项目首页说明
├── LICENSE                       # MIT许可证
├── CHANGELOG.md                  # 更新日志
├── .gitignore                   # Git忽略配置
├── docs/
│   ├── PRD.md                  # 产品需求文档
│   ├── DEVELOPMENT.md          # 开发指南（本文档）
│   └── SCREENS.md             # 产品截图展示
├── assets/
│   └── AppIcon-Design.md       # App图标设计方案
├── src/
│   ├── MacScreenshot.xcodeproj/        # Xcode项目
│   │   └── project.pbxproj               # 项目配置
│   └── MacScreenshot/                  # 应用主目标
│       ├── Info.plist                 # 应用信息配置
│       ├── Sources/
│       │   ├── AppDelegate.swift       # 应用生命周期入口
│       │   ├── StatusBarManager.swift  # 状态栏菜单管理
│       │   ├── ScreenshotManager.swift # 截图流程管理
│       │   ├── CaptureEngine.swift     # 屏幕捕获引擎
│       │   ├── AnnotationCanvasViewController.swift # 标注画布
│       │   ├── Tools/                 # 标注工具
│       │   │   ├── AnnotationTool.swift    # 工具协议定义
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
│       │   │   ├── PreferencesWindowController.swift # 偏好设置窗口
│       │   │   └── ColorPicker.swift                 # 颜色选择器
│       │   └── Utils/                  # 工具类
│       │       ├── KeyboardShortcutManager.swift    # 全局快捷键管理
│       │       └── FileUtils.swift              # 文件工具
│       └── Resources/
│           └── Assets.xcassets/
│               └── AppIcon.appiconset/    # App图标
├── images/                 # 产品截图（用于README）
└── assets/                 # 设计资源文件
```

---

## 3. 编译运行

### 3.1 首次编译
1. 克隆项目到本地
2. 打开 `src/MacScreenshot.xcodeproj`
3. 选择开发Team（需要你自己的Apple开发者账号）
4. 点击编译运行 ⌘+R

### 3.2 签名设置
- 在 `TARGETS → MacScreenshot → Signing & Capabilities` 中设置你的开发账号
- 调试版本无需付费开发者账号即可运行

### 3.3 打包发布
1. 选择 `Any Mac` 作为目标
2. 菜单 `Product → Archive`
3. 打包完成后导出 `.dmg` 文件

---

## 4. 代码架构

### 4.1 整体架构
采用传统MVC架构，保持简单清晰：

```
AppDelegate → StatusBarManager → ScreenshotManager → CaptureEngine → AnnotationCanvas
```

### 4.2 核心模块说明

| 模块 | 职责 |
|------|------|
| `AppDelegate` | 应用生命周期管理，菜单栏初始化 |
| `StatusBarManager` | 状态栏图标管理，处理全局菜单 |
| `ScreenshotManager` | 截图流程管理，协调各个模块 |
| `CaptureEngine` | 屏幕捕获核心，处理CGImage获取 |
| `AnnotationCanvas` | 标注画布，管理所有标注元素 |
| `AnnotationTool` 协议 | 标注工具协议，所有工具遵循此协议 |

### 4.3 标注工具设计
所有标注工具都遵循 `AnnotationTool` 协议，这种设计方便新增工具，符合开闭原则。

```swift
protocol AnnotationTool {
    var name: String { get }
    var iconName: String { get }
    var color: NSColor { get set }
    var lineWidth: CGFloat { get set }
    
    func begin(at point: CGPoint, in canvas: AnnotationCanvas)
    func drag(to point: CGPoint, in canvas: AnnotationCanvas)
    func end(at point: CGPoint, in canvas: AnnotationCanvas) -> Bool
    func cancel()
    func finalize() -> AnnotationElement
}
```

---

## 5. 开发规范

### 5.1 代码风格
- 遵循 [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- 使用 4 空格缩进
- 每行长度不超过 120 字符
- 文件末尾保留一个空行

### 5.2 命名规范
- 类名：大驼峰 `class ScreenshotManager`
- 方法/变量：小驼峰 `func captureScreen()`
- 常量：全大写 `let MAX_IMAGE_SIZE: CGFloat = 8192`

### 5.3 注释规范
- 公开方法需要注释说明用途
- 复杂算法需要说明实现思路
- 使用 MARK: 分组分类代码

```swift
// MARK: - Public Methods
public func startCapture() {
    // ...
}

// MARK: - Private Methods
private func prepareCapture() {
    // ...
}
```

### 5.4 Git提交规范
提交信息格式：
```
type(scope): description

# 示例
feat(capture): add delay capture support
fix(toolbar): resolve color picker display issue
docs(readme): update installation instructions
```

**type 可选值**：
- `feat`: 新功能
- `fix`: 修复Bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 重构
- `perf`: 性能优化
- `test`: 测试相关

---

## 6. 提交贡献

### 6.1 提Issue
- 欢迎提交 [Issue](https://github.com/LiangJunChan/mac-screenshot-annotator/issues) 报告Bug或建议新功能
- 请说明你的系统版本、Xcode版本，并提供截图

### 6.2 提Pull Request
1. Fork本仓库
2. 创建特性分支 `git checkout -b feature/your-feature-name`
3. 提交你的改动 `git commit -m "feat: add some feature"`
4. Push到你的分支 `git push origin feature/your-feature-name`
5. 创建Pull Request

### 6.3 开发流程
- `main` 分支是主分支，保持可发布状态
- 开发新功能请开新分支，合并后删除
- 每次发布打对应版本Tag

---

## 7. 发布流程

### 7.1 版本号
遵循 [语义化版本](https://semver.org/lang/zh-CN/) `MAJOR.MINOR.PATCH`
- **主版本**: 不兼容的API修改
- **次版本**: 新增功能，向下兼容
- **修订版本**: Bug修复，向下兼容

### 7.2 发布步骤
1. 更新 `CHANGELOG.md`
2. 更新项目版本号（Xcode中）
3. 打Git Tag `git tag -a v1.0.0 -m "Release v1.0.0"`
4. Push Tag `git push origin v1.0.0`
5. 在GitHub Releases发布，附上编译好的`.dmg`文件
6. 更新README中下载链接

### 7.3 更新检查
应用内集成简单的GitHub更新检查，对比Releases版本提示用户更新。

---

## 📄 许可证
本项目采用 MIT 许可证，详见 [LICENSE](../LICENSE)。
