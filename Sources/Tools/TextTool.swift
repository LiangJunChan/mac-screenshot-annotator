//
//  TextTool.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class TextTool: AnnotationTool {
    var name: String = "文字"
    var iconName: String = "text-tool"
    var color: NSColor = .black
    var lineWidth: CGFloat = 14.0 // 字号
    
    private var startPoint: CGPoint?
    private var currentText: String = ""
    private var currentElement: TextElement?
    
    func begin(at point: CGPoint, in canvas: AnnotationCanvas) {
        startPoint = point
        currentText = ""
        currentElement = TextElement(text: "", position: point, color: color, fontSize: lineWidth)
        canvas.setCurrentPreviewElement(currentElement!)
        // 开始编辑文字
        canvas.startEditingText(at: point, textTool: self)
        canvas.setNeedsDisplay()
    }
    
    func drag(to point: CGPoint, in canvas: AnnotationCanvas) {
        // 文字工具不需要drag
    }
    
    func end(at point: CGPoint, in canvas: AnnotationCanvas) -> Bool {
        guard let element = currentElement, !element.text.isEmpty else {
            return false
        }
        canvas.addAnnotation(element)
        canvas.clearPreview()
        startPoint = nil
        currentText = ""
        currentElement = nil
        return true
    }
    
    func cancel() {
        startPoint = nil
        currentText = ""
        currentElement = nil
    }
    
    func finalize() -> AnnotationElement {
        return currentElement!
    }
    
    func updateText(_ text: String) {
        currentElement?.text = text
    }
}

class TextElement: AnnotationElement {
    var text: String
    var position: CGPoint
    var fontSize: CGFloat
    
    init(text: String, position: CGPoint, color: NSColor, fontSize: CGFloat) {
        self.text = text
        self.position = position
        self.fontSize = fontSize
        super.init(color: color, lineWidth: fontSize)
    }
    
    override func draw(in context: CGContext) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize),
            .foregroundColor: color
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: position)
    }
    
    override func contains(point: CGPoint) -> Bool {
        let textSize = (text as NSString).size(withAttributes: [
            .font: NSFont.systemFont(ofSize: fontSize)
        ])
        let rect = CGRect(origin: position, size: textSize)
        return rect.insetBy(dx: -5, dy: -5).contains(point)
    }
}
