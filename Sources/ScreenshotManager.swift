//
//  ScreenshotManager.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

enum CaptureMode {
    case area       // 区域截图
    case fullScreen  // 全屏截图
    case window     // 窗口截图
    case delay      // 延时截图
}

class ScreenshotManager: NSObject {
    static let shared = ScreenshotManager()
    
    var currentCaptureMode: CaptureMode = .area
    var captureWindow: NSWindow!
    var annotationViewController: AnnotationCanvasViewController!
    
    private override init() {
        super.init()
    }
    
    func startCapture(mode: CaptureMode) {
        currentCaptureMode = mode
        
        switch mode {
        case .area:
            startAreaCapture()
        case .fullScreen:
            captureFullScreen()
        case .window:
            startWindowCapture()
        case .delay:
            startDelayCapture()
        }
    }
    
    private func startAreaCapture() {
        // 进入区域选择模式
        let captureEngine = CaptureEngine.shared
        captureEngine.beginAreaCapture { [weak self] image in
            guard let image = image else {
                return
            }
            self?.showAnnotationCanvas(with: image)
        }
    }
    
    private func captureFullScreen() {
        let image = CaptureEngine.shared.captureFullScreen()
        showAnnotationCanvas(with: image)
    }
    
    private func startWindowCapture() {
        // 窗口选择模式
        CaptureEngine.shared.beginWindowCapture { [weak self] image in
            guard let image = image else {
                return
            }
            self?.showAnnotationCanvas(with: image)
        }
    }
    
    private func startDelayCapture() {
        // 延时截图
        let delay = Settings.shared.defaultDelaySeconds
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            let image = CaptureEngine.shared.captureFullScreen()
            self?.showAnnotationCanvas(with: image)
        }
    }
    
    private func showAnnotationCanvas(with image: NSImage) {
        // 创建标注画布窗口
        let canvas = AnnotationCanvasViewController(image: image)
        self.annotationViewController = canvas
        
        let window = NSWindow(contentViewController: canvas)
        window.styleMask = [.borderless, .fullSizeContentView]
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = false
        window.level = .screenSaver
        window.makeKeyAndOrderFront(nil)
        window.toggleFullScreen(nil)
        
        self.captureWindow = window
    }
    
    func finishAnnotation(image: NSImage) {
        // 导出处理
        exportImage(image)
        captureWindow.close()
        captureWindow = nil
        annotationViewController = nil
    }
    
    func cancelCapture() {
        captureWindow.close()
        captureWindow = nil
        annotationViewController = nil
    }
    
    private func exportImage(_ image: NSImage) {
        // 复制到剪贴板
        if Settings.shared.autoCopyToClipboard {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.write([image])
        }
        
        // 保存到文件
        if Settings.shared.autoSaveToFile {
            FileUtils.shared.saveImageToDefaultLocation(image) { success in
                if success {
                    // 可以显示一个成功提示
                }
            }
        }
    }
}
