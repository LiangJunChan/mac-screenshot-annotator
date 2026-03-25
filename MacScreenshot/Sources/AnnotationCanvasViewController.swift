//
//  AnnotationCanvasViewController.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

protocol AnnotationCanvasDelegate: AnyObject {
    func didFinishAnnotation(with image: NSImage)
    func didCancelAnnotation()
}

class AnnotationCanvasViewController: NSViewController {
    
    weak var delegate: AnnotationCanvasDelegate?
    
    var originalImage: NSImage
    var canvasView: AnnotationCanvas!
    var toolbar: AnnotationToolbar!
    
    init(image: NSImage) {
        self.originalImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let windowFrame = NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 1920, height: 1080)
        view = NSView(frame: windowFrame)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.3).cgColor
        
        setupCanvas()
        setupToolbar()
    }
    
    private func setupCanvas() {
        canvasView = AnnotationCanvas(frame: view.bounds, image: originalImage)
        canvasView.autoresizingMask = [.width, .height]
        view.addSubview(canvasView)
    }
    
    private func setupToolbar() {
        let toolbarHeight: CGFloat = 50
        let toolbarY: CGFloat = view.bounds.height - toolbarHeight - 20
        let toolbarFrame = CGRect(
            x: (view.bounds.width - 400) / 2,
            y: toolbarY,
            width: 400,
            height: toolbarHeight
        )
        
        toolbar = AnnotationToolbar(frame: toolbarFrame)
        toolbar.toolbarDelegate = self
        view.addSubview(toolbar)
    }
    
    func done() {
        if let resultImage = canvasView.getAnnotatedImage() {
            ScreenshotManager.shared.finishAnnotation(image: resultImage)
        }
    }
    
    func cancel() {
        ScreenshotManager.shared.cancelCapture()
    }
}

// MARK: - AnnotationCanvas

class AnnotationCanvas: NSView {
    
    var originalImage: NSImage
    var annotations: [AnnotationElement] = []
    var currentPreview: AnnotationElement?
    var currentTool: AnnotationTool?
    
    private var imageFrame: CGRect = .zero
    
    init(frame: NSRect, image: NSImage) {
        self.originalImage = image
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        wantsLayer = true
        calculateImageFrame()
    }
    
    private func calculateImageFrame() {
        let imageSize = originalImage.size
        let viewSize = bounds.size
        
        let scale: CGFloat
        if imageSize.width / imageSize.height > viewSize.width / viewSize.height {
            scale = viewSize.width / imageSize.width
        } else {
            scale = viewSize.height / imageSize.height
        }
        
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        let x = (viewSize.width - scaledWidth) / 2
        let y = (viewSize.height - scaledHeight) / 2
        imageFrame = CGRect(x: x, y: y, width: scaledWidth, height: scaledHeight)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        // 绘制背景黑色半透明
        NSColor.black.withAlphaComponent(0.3).setFill()
        context.fill(bounds)
        
        // 绘制原始截图
        originalImage.draw(in: imageFrame)
        
        // 绘制所有标注
        for annotation in annotations {
            annotation.draw(in: context)
        }
        
        // 绘制当前预览
        if let preview = currentPreview {
            preview.draw(in: context)
        }
    }
    
    // MARK: - Public Methods
    
    func addAnnotation(_ annotation: AnnotationElement) {
        annotations.append(annotation)
        setNeedsDisplay(bounds)
    }
    
    func setCurrentPreviewElement(_ element: AnnotationElement) {
        currentPreview = element
    }
    
    func clearPreview() {
        currentPreview = nil
    }
    
    func getAnnotatedImage() -> NSImage? {
        // 创建一个新图像包含原始图像加上所有标注
        let size = originalImage.size
        let image = NSImage(size: size)
        image.lockFocus()
        
        originalImage.draw(at: .zero, from: CGRect(origin: .zero, size: size), operation: .sourceOver, fraction: 1.0)
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            image.unlockFocus()
            return image
        }
        
        for annotation in annotations {
            annotation.draw(in: context)
        }
        
        image.unlockFocus()
        return image
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay(bounds)
    }
    
    // MARK: - Mouse Events
    
    override func mouseDown(with event: NSEvent) {
        guard let tool = currentTool else { return }
        let location = convert(event.locationInWindow, from: nil)
        tool.begin(at: location, in: self)
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let tool = currentTool else { return }
        let location = convert(event.locationInWindow, from: nil)
        tool.drag(to: location, in: self)
    }
    
    override func mouseUp(with event: NSEvent) {
        guard let tool = currentTool else { return }
        let location = convert(event.locationInWindow, from: nil)
        if tool.end(at: location, in: self) {
            // 完成本次绘制，保持工具选中
            setNeedsDisplay(bounds)
        } else {
            // 取消，清除预览
            clearPreview()
            setNeedsDisplay(bounds)
        }
    }
}

// MARK: - AnnotationToolbar

protocol AnnotationToolbarDelegate: AnyObject {
    func didSelectTool(_ tool: AnnotationTool)
    func didFinish()
    func didCancel()
    func undo()
    func redo()
}

class AnnotationToolbar: NSView {
    
    weak var toolbarDelegate: AnnotationToolbarDelegate?
    private var buttons: [NSButton] = []
    
    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.cornerRadius = 8
        layer?.backgroundColor = NSColor.darkGray.withAlphaComponent(0.9).cgColor
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtons() {
        let tools: [(String, Annotation.Type)] = [
            ("⬜️", RectTool.self),
            ("⭕️", EllipseTool.self),
            ("➡️", ArrowTool.self),
            ("✏️", PenTool.self),
            ("🔤", TextTool.self),
            ("🔲", MosaicTool.self),
        ]
        
        let buttonWidth: CGFloat = 40
        let spacing: CGFloat = 8
        let totalWidth = CGFloat(tools.count) * (buttonWidth + spacing) - spacing
        let startX = (bounds.width - totalWidth) / 2
        
        for (index, (icon, toolClass)) in tools.enumerated() {
            let buttonX = startX + CGFloat(index) * (buttonWidth + spacing)
            let buttonFrame = CGRect(x: buttonX, y: 5, width: buttonWidth, height: 40)
            let button = NSButton(frame: buttonFrame)
            button.title = icon
            button.font = NSFont.systemFont(ofSize: 18)
            button.bezelStyle = .rounded
            button.target = self
            button.action = #selector(toolClicked(_:))
            button.tag = index
            addSubview(button)
            buttons.append(button)
        }
        
        // 添加完成和取消按钮
        let doneX = totalWidth + spacing + 10
        let doneButton = NSButton(frame: CGRect(x: doneX, y: 5, width: 60, height: 40))
        doneButton.title = "✅ 完成"
        doneButton.bezelStyle = .rounded
        doneButton.target = self
        doneButton.action = #selector(doneClicked(_:))
        addSubview(doneButton)
        
        let cancelX = doneX + 60 + spacing
        let cancelButton = NSButton(frame: CGRect(x: cancelX, y: 5, width: 60, height: 40))
        cancelButton.title = "❌ 取消"
        cancelButton.bezelStyle = .rounded
        cancelButton.target = self
        cancelButton.action = #selector(cancelClicked(_:))
        addSubview(cancelButton)
    }
    
    @objc private func toolClicked(_ sender: NSButton) {
        // 根据tag创建对应工具
        let tool: AnnotationTool
        switch sender.tag {
        case 0: tool = RectTool()
        case 1: tool = EllipseTool()
        case 2: tool = ArrowTool()
        case 3: tool = PenTool()
        case 4: tool = TextTool()
        case 5: tool = MosaicTool()
        default: tool = RectTool()
        }
        toolbarDelegate?.didSelectTool(tool)
        
        // 高亮选中
        for (idx, btn) in buttons.enumerated() {
            btn.isHighlighted = idx == sender.tag
        }
    }
    
    @objc private func doneClicked(_ sender: NSButton) {
        toolbarDelegate?.didFinish()
    }
    
    @objc private func cancelClicked(_ sender: NSButton) {
        toolbarDelegate?.didCancel()
    }
}

extension AnnotationToolbar: AnnotationToolbarDelegate {
    func didSelectTool(_ tool: AnnotationTool) {
        (view.window?.contentViewController as? AnnotationCanvasViewController)?.canvasView.currentTool = tool
    }
    
    func didFinish() {
        (view.window?.contentViewController as? AnnotationCanvasViewController)?.done()
    }
    
    func didCancel() {
        (view.window?.contentViewController as? AnnotationCanvasViewController)?.cancel()
    }
}
