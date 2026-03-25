//
//  StatusBarManager.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class StatusBarManager: NSObject {
    static let shared = StatusBarManager()
    
    var statusBar: NSStatusBar!
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    
    override init() {
        super.init()
    }
    
    func setupStatusBar() {
        statusBar = NSStatusBar.shared()
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        
        // 设置状态栏图标
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            button.image?.isTemplate = true // 自动适配暗色/亮色模式
        }
        
        // 构建菜单
        buildMenu()
        
        // 设置状态项
        statusItem.menu = menu
    }
    
    private func buildMenu() {
        menu = NSMenu()
        
        // 区域截图
        addMenuItem(title: "区域截图", action: #selector(captureArea(_:)), keyEquivalent: "")
        
        // 全屏截图
        addMenuItem(title: "全屏截图", action: #selector(captureFullScreen(_:)), keyEquivalent: "")
        
        // 窗口截图
        addMenuItem(title: "窗口截图", action: #selector(captureWindow(_:)), keyEquivalent: "")
        
        // 分隔线
        menu.addItem(NSMenuItem.separator())
        
        // 偏好设置
        addMenuItem(title: "偏好设置...", action: #selector(openPreferences(_:)), keyEquivalent: ",")
        
        // 分隔线
        menu.addItem(NSMenuItem.separator())
        
        // 检查更新
        addMenuItem(title: "检查更新", action: #selector(checkUpdates(_:)), keyEquivalent: "")
        
        // 关于
        addMenuItem(title: "关于 MacScreenshot", action: #selector(showAbout(_:)), keyEquivalent: "")
        
        // 分隔线
        menu.addItem(NSMenuItem.separator())
        
        // 退出
        addMenuItem(title: "退出", action: #selector(quit(_:)), keyEquivalent: "q")
    }
    
    private func addMenuItem(title: String, action: Selector, keyEquivalent: String) {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        item.target = self
        menu.addItem(item)
    }
    
    // MARK: - Actions
    
    @objc func captureArea(_ sender: Any) {
        ScreenshotManager.shared.startCapture(mode: .area)
    }
    
    @objc func captureFullScreen(_ sender: Any) {
        ScreenshotManager.shared.startCapture(mode: .fullScreen)
    }
    
    @objc func captureWindow(_ sender: Any) {
        ScreenshotManager.shared.startCapture(mode: .window)
    }
    
    @objc func openPreferences(_ sender: Any) {
        PreferencesWindowController.shared.showWindow(sender)
    }
    
    @objc func checkUpdates(_ sender: Any) {
        // TODO: 实现更新检查
    }
    
    @objc func showAbout(_ sender: Any) {
        NSApplication.shared.orderFrontStandardAboutPanel(options: [:])
    }
    
    @objc func quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}
