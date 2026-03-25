//
//  MosaicTool.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class MosaicTool: AnnotationTool {
    var name: String = "马赛克"
    var iconName: String = "mosaic-tool"
    var color: NSColor = .clear // 马赛克不需要线条颜色
    var lineWidth: CGFloat = 16.0 // 马赛克块大小
    
    private var startPoint: CGPoint?
    private var currentRect: CGRect?
    private var currentElement: MosaicElement?
    
    func begin(at point: CGPoint, in canvas: AnnotationCanvas) {
        startPoint = point
        currentRect = CGRect(origin: point, size: .zero)
    }
    
    func drag(to point: CGPoint, in canvas: AnnotationCanvas) {
        guard let start = startPoint else { return }
        let rect = CGRect(x: min(start.x, point.x), y: min(start.y, point.y),
                          width: abs(start.x - point.x), height: abs(start.y - point.y))
        currentRect = rect
        currentElement = MosaicElement(rect: rect, blockSize: lineWidth)
        canvas.setCurrentPreviewElement(currentElement!)
        canvas.setNeedsDisplay()
    }
    
    func end(at point: CGPoint, in canvas: AnnotationCanvas) -> Bool {
        guard let element = currentElement, let start = startPoint else {
            return false
        }
        
        if element.rect.width < 10 || element.rect.height < 10 {
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

class MosaicElement: AnnotationElement {
    var rect: CGRect
    var blockSize: CGFloat
    
    init(rect: CGRect, blockSize: CGFloat) {
        self.rect = rect
        self.blockSize = blockSize
        super.init(color: .clear, lineWidth: blockSize)
    }
    
    override func draw(in context: CGContext) {
        // 绘制马赛克格子效果
        context.saveGState()
        context.clip(to: rect)
        
        // 绘制块化效果
        let blockSize = blockSize
        let gridWidth = Int(ceil(rect.width / blockSize))
        let gridHeight = Int(ceil(rect.height / blockSize))
        
        for y in 0..<gridHeight {
            for x in 0..<gridWidth {
                let blockRect = CGRect(
                    x: rect.minX + CGFloat(x) * blockSize,
                    y: rect.minY + CGFloat(y) * blockSize,
                    width: blockSize,
                    height: blockSize
                )
                
                // 平均颜色这里简化处理，直接半透明灰色
                let gray = CGFloat(arc4random() % 60) / 255 + 0.4
                context.setFillColor(NSColor(white: gray, alpha: 0.8).cgColor)
                context.fill(blockRect)
                
                // 轻微边框
                context.setStrokeColor(NSColor.white.withAlphaComponent(0.3).cgColor)
                context.setLineWidth(0.5)
                context.stroke(blockRect)
            }
        }
        
        context.restoreGState()
    }
    
    override func contains(point: CGPoint) -> Bool {
        return rect.contains(point)
    }
}
