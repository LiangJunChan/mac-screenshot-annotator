//
//  CaptureEngine.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class CaptureEngine: NSObject {
    static let shared = CaptureEngine()
    
    private override init() {
        super.init()
    }
    
    /// 捕获全屏
    func captureFullScreen() -> NSImage {
        let screens = NSScreen.screens
        guard let mainScreen = screens.first else {
            return NSImage()
        }
        
        let displayID = mainScreen.deviceDescription[NSDeviceDescriptionKey(kCGDirectDisplayID)]!
        let cgImage = CGDisplayCopyImage(displayID as! CGDirectDisplayID)
        return NSImage(cgImage: cgImage!, size: mainScreen.frame.size)
    }
    
    /// 开始区域选择捕获
    func beginAreaCapture(completion: @escaping (NSImage?) -> Void) {
        // 创建半透明遮罩窗口
        // 让用户拖拽选择区域
        // 完成后调用completion返回图片
    }
    
    /// 开始窗口选择捕获
    func beginWindowCapture(completion: @escaping (NSImage?) -> Void) {
        // 让用户点击选择窗口
        // 捕获选中窗口
        // 完成后调用completion返回图片
    }
}
