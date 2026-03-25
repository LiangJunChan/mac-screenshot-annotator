//
//  AppDelegate.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarManager: StatusBarManager!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 初始化状态栏管理
        statusBarManager = StatusBarManager.shared
        statusBarManager.setupStatusBar()
        
        // 注册快捷键
        KeyboardShortcutManager.shared.registerGlobalShortcuts()
        
        // 设置权限请求（屏幕录制需要权限）
        requestScreenRecordingPermissionIfNeeded()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // 清理资源
        KeyboardShortcutManager.shared.unregisterAllShortcuts()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    private func requestScreenRecordingPermissionIfNeeded() {
        // 检查屏幕录制权限
        // 如果没有权限，提示用户去系统设置开启
    }
}
