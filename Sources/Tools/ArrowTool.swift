//
//  ArrowTool.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class ArrowTool: AnnotationTool {
    var name: String = "箭头"
    var iconName: String = "arrow-tool"
    var color: NSColor = NSColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
    var lineWidth: CGFloat = 6.0
    
    private var startPoint: CGPoint?
    private var endPoint: CGPoint?
    private var currentElement: ArrowElement?
    
    func begin(at point: CGPoint, in canvas: AnnotationCanvas) {
        startPoint = point
        endPoint = point
    }
    
    func drag(to point: CGPoint, in canvas: AnnotationCanvas) {
        endPoint = point
        guard let start = startPoint, let end = endPoint else { return }
        currentElement = ArrowElement(start: start, end: end, color: color, lineWidth: lineWidth)
        canvas.setCurrentPreviewElement(currentElement!)
        canvas.setNeedsDisplay()
    }
    
    func end(at point: CGPoint, in canvas: AnnotationCanvas) -> Bool {
        guard let element = currentElement, let start = startPoint else {
            return false
        }
        
        // 如果太短，可能是误触
        let distance = hypot(start.x - point.x, start.y - point.y)
        if distance < 10 {
            return false
        }
        
        canvas.addAnnotation(element)
        canvas.clearPreview()
        startPoint = nil
        endPoint = nil
        currentElement = nil
        return true
    }
    
    func cancel() {
        startPoint = nil
        endPoint = nil
        currentElement = nil
    }
    
    func finalize() -> AnnotationElement {
        return currentElement!
    }
}

class ArrowElement: AnnotationElement {
    var start: CGPoint
    var end: CGPoint
    
    init(start: CGPoint, end: CGPoint, color: NSColor, lineWidth: CGFloat) {
        self.start = start
        self.end = end
        super.init(color: color, lineWidth: lineWidth)
    }
    
    override func draw(in context: CGContext) {
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.move(to: start)
        context.addLine(to: end)
        context.strokePath()
        
        // 绘制箭头三角
        let angle = atan2(end.y - start.y, end.x - start.x)
        let arrowSize: CGFloat = lineWidth * 2.5
        
        context.move(to: end)
        context.addLine(to: end - CGPoint(x: arrowSize * cos(angle - .pi / 6),
                                         y: arrowSize * sin(angle - .pi / 6)))
        context.move(to: end)
        context.addLine(to: end - CGPoint(x: arrowSize * cos(angle + .pi / 6),
                                         y: arrowSize * sin(angle + .pi / 6)))
        context.strokePath()
    }
    
    override func contains(point: CGPoint) -> Bool {
        // 简化判断：点到线段的距离小于一定值就算命中
        let distance = distanceFromPointToLineSegment(point, lineStart: start, lineEnd: end)
        return distance < (lineWidth + 6)
    }
    
    private func distanceFromPointToLineSegment(_ point: CGPoint, lineStart: CGPoint, lineEnd: CGPoint) -> CGFloat {
        let A = point.x - lineStart.x
        let B = point.y - lineStart.y
        let C = lineEnd.x - lineStart.x
        let D = lineEnd.y - lineStart.y
        
        let dot = A * C + B * D
        if dot <= 0 {
            return hypot(A, B)
        }
        
        let lenSq = C * C + D * D
        if dot >= lenSq {
            return hypot(point.x - lineEnd.x, point.y - lineEnd.y)
        }
        
        let param = dot / lenSq
        let xx = lineStart.x + param * C
        let yy = lineStart.y + param * D
        return hypot(point.x - xx, point.y - yy)
    }
}

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
