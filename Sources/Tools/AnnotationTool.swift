//
//  AnnotationTool.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

protocol AnnotationTool {
    /// 工具名称
    var name: String { get }
    /// 图标名称（在Assets中）
    var iconName: String { get }
    /// 工具当前颜色
    var color: NSColor { get set }
    /// 工具当前线宽
    var lineWidth: CGFloat { get set }
    
    /// 开始绘制，在point点开始
    func begin(at point: CGPoint, in canvas: AnnotationCanvas)
    /// 拖动到point点
    func drag(to point: CGPoint, in canvas: AnnotationCanvas)
    /// 结束绘制在point点
    func end(at point: CGPoint, in canvas: AnnotationCanvas) -> Bool
    /// 取消当前绘制
    func cancel()
    /// 完成绘制，返回生成的标注元素
    func finalize() -> AnnotationElement
}

/// 标注元素基类
class AnnotationElement: NSObject {
    var color: NSColor
    var lineWidth: CGFloat
    var isSelected: Bool = false
    
    init(color: NSColor, lineWidth: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth
        super.init()
    }
    
    func draw(in context: CGContext) {
        fatalError("Must be overridden by subclass")
    }
    
    func contains(point: CGPoint) -> Bool {
        return false
    }
    
    func move(to delta: CGPoint) {
        // 默认不支持移动，子类可以重写
    }
}
