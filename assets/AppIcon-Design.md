# App图标设计方案 - MacScreenshot

## 🎨 设计理念

### 设计思路
MacScreenshot 是一款简洁轻量的截图标注工具，图标设计应该体现：
- **简洁** - 不复杂，识别度高
- **直观** - 一眼能看出是截图工具
- **现代** - 符合macOS设计风格
- **识别** - 在Dock中清晰可辨

### 色彩方案
- **主色**: 深蓝色 `#2c7be5` - 代表科技、专业
- **背景渐变**: 从 `#2c7be5` → `#1a56db`
- **前景色**: 白色线条，保持对比度
- 自动适配暗色/亮色模式

---

## 🖼️ 设计方案

### 方案一：相机+裁剪框设计（推荐）

```
┌─────────────────────┐
│  ┌────────────────┐  │
│  │                │  │
│  │     📷         │  │
│  │                │  │
│  └────────────────┘  │
└─────────────────────┘
```

**描述**:
- 外框圆角矩形代表截图区域
- 中间一个小相机图标代表摄影/截图
- 整体简洁直观

---

### 方案二：剪刀+画面设计

```
✂️
```

**描述**:
- 剪刀图标直接表达"剪裁"含义
- 剪刀加矩形背景

---

### 方案三：箭头标注设计（推荐备选）

```svg
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <!-- 背景渐变圆形 -->
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#2c7be5"/>
      <stop offset="100%" stop-color="#1a56db"/>
    </linearGradient>
  </defs>
  
  <!-- 圆形背景 -->
  <circle cx="512" cy="512" r="480" fill="url(#bgGradient)"/>
  
  <!-- 白色边框矩形 -->
  <rect x="200" y="260" width="624" height="504" rx="24" 
        fill="none" stroke="white" stroke-width="28"/>
  
  <!-- 箭头 -->
  <path d="M 300 380 L 720 620" 
        stroke="white" stroke-width="36" stroke-linecap="round" fill="none"/>
  <polygon points="700 600 720 620 680 640" fill="white"/>
  <circle cx="300" cy="380" r="28" fill="white"/>
</svg>
```

**描述**:
- 矩形代表截图
- 箭头代表标注
- 组合起来就是"截图+标注"，非常直观

---

## 💾 导出说明

1. 使用上面SVG代码保存为 `icon.svg`
2. 在Figma/Sketch中打开
3. 导出 1024x1024 PNG
4. 拖入Xcode `Assets.xcassets/AppIcon.appiconset`
5. Xcode自动生成所有尺寸

---

## 🎯 最终推荐

**推荐方案：方案三**（矩形+箭头）
- 直观表达"截图+标注"含义
- 简洁、识别度高
- 符合macOS简约设计风格
- 配色专业好看

备选方案：方案一（相机+矩形）
