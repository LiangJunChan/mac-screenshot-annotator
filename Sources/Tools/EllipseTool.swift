//
//  EllipseTool.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class EllipseTool: AnnotationTool {
    var name: String = "椭圆"
    var iconName: String = "ellipse-tool"
    var color: NSColor = NSColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
    var lineWidth: CGFloat = 3.0
    
    private var startPoint: CGPoint?
    private var currentRect: CGRect?
    private var currentElement: EllipseElement?
    
    func begin(at point: CGPoint, in canvas: AnnotationCanvas) {
        startPoint = point
        currentRect = CGRect(origin: point, size: .zero)
    }
    
    func drag(to point: CGPoint, in canvas: AnnotationCanvas) {
        guard let start = startPoint else { return }
        let rect = CGRect(x: min(start.x, point.x), y: min(start.y, point.y),
                          width: abs(start.x - point.x), height: abs(start.y - point.y))
        currentRect = rect
        currentElement = EllipseElement(rect: rect, color: color, lineWidth: lineWidth)
        canvas.setCurrentPreviewElement(currentElement!)
        canvas.setNeedsDisplay()
    }
    
    func end(at point: CGPoint, in canvas: AnnotationCanvas) -> Bool {
        guard let element = currentElement, let start = startPoint else {
            return false
        }
        
        if element.rect.width < 5 || element.rect.height < 5 {
            return false
        }
        
        canvas.addAnnotation(element)
        canvas.clearPreview()
        startPoint = nil
        currentRect = nil
        currentElement = nil
        return true
    }
    
    func cancel() {
        startPoint = nil
        currentRect = nil
        currentElement = nil
    }
    
    func finalize() -> AnnotationElement {
        return currentElement!
    }
}

class EllipseElement: AnnotationElement {
    var rect: CGRect
    
    init(rect: CGRect, color: NSColor, lineWidth: CGFloat) {
        self.rect = rect
        super.init(color: color, lineWidth: lineWidth)
    }
    
    override func draw(in context: CGContext) {
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        context.strokeEllipse(in: rect.insetBy(dx: lineWidth/2, dy: lineWidth/2))
    }
    
    override func contains(point: CGPoint) -> Bool {
        let expandedRect = rect.insetBy(dx: -5, dy: -5)
        return expandedRect.contains(point)
    }
}
