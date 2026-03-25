//
//  PreferencesWindowController.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    
    static let shared = PreferencesWindowController()
    
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "偏好设置 - MacScreenshot"
        self.init(window: window)
        let contentViewController = PreferencesViewController()
        window.contentViewController = contentViewController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // 加载当前设置到UI
    }
}

// 如果不用storyboard的话，手动构建UI
class PreferencesViewController: NSViewController {
    
    override func loadView() {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 500, height: 400))
        self.view = view
        // 这里可以添加各个设置控件
        // 完整UI开发留到后续阶段
    }
}
