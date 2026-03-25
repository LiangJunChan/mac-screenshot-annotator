//
//  PenTool.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class PenTool: AnnotationTool {
    var name: String = "画笔"
    var iconName: String = "pen-tool"
    var color: NSColor = NSColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
    var lineWidth: CGFloat = 5.0
    
    private var points: [CGPoint] = []
    private var currentElement: PenElement?
    
    func begin(at point: CGPoint, in canvas: AnnotationCanvas) {
        points = [point]
        currentElement = PenElement(points: points, color: color, lineWidth: lineWidth)
        canvas.setCurrentPreviewElement(currentElement!)
        canvas.setNeedsDisplay()
    }
    
    func drag(to point: CGPoint, in canvas: AnnotationCanvas) {
        points.append(point)
        currentElement = PenElement(points: points, color: color, lineWidth: lineWidth)
        canvas.setCurrentPreviewElement(currentElement!)
        canvas.setNeedsDisplay()
    }
    
    func end(at point: CGPoint, in canvas: AnnotationCanvas) -> Bool {
        guard let element = currentElement, points.count >= 2 else {
            return false
        }
        
        canvas.addAnnotation(element)
        canvas.clearPreview()
        points.removeAll()
        currentElement = nil
        return true
    }
    
    func cancel() {
        points.removeAll()
        currentElement = nil
    }
    
    func finalize() -> AnnotationElement {
        return currentElement!
    }
}

class PenElement: AnnotationElement {
    var points: [CGPoint]
    
    init(points: [CGPoint], color: NSColor, lineWidth: CGFloat) {
        self.points = points
        super.init(color: color, lineWidth: lineWidth)
    }
    
    override func draw(in context: CGContext) {
        guard points.count >= 2 else { return }
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.move(to: points[0])
        for point in points.dropFirst() {
            context.addLine(to: point)
        }
        context.strokePath()
    }
    
    override func contains(point: CGPoint) -> Bool {
        // 简化判断：检查点到任何线段的距离
        for i in 0..<points.count-1 {
            let distance = distanceFromPointToLineSegment(point, lineStart: points[i], lineEnd: points[i+1])
            if distance < (lineWidth + 4) {
                return true
            }
        }
        return false
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
