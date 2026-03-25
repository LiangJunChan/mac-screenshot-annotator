//
//  KeyboardShortcutManager.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa
import Carbon

class KeyboardShortcutManager: NSObject {
    static let shared = KeyboardShortcutManager()
    
    private var eventHotKey: [UInt32: EventHotKeyRef] = [:]
    private var hotKeyIDs: [String: UInt32] = [:]
    private var nextHotKeyID: UInt32 = 1
    private var callbackMap: [UInt32: () -> Void] = [:]
    
    private override init() {
        super.init()
        // 注册事件处理器
        InstallEventHandler({ (eventHandler, callRef, userData) -> OSStatus in
            guard let callRef = callRef else { return -1 }
            var event = callRef
            let hotKeyID = GetEventHotKeyID(&event)
            if let callback = self.callbackMap[hotKeyID.id] {
                DispatchQueue.main.async {
                    callback()
                }
            }
            return noErr
        }, kEventClassKeyboard, kEventHotKeyPressed, nil, Unmanaged.passUnretained(self).toOpaque())
    }
    
    func registerGlobalShortcuts() {
        // 注册各个快捷键
        registerShortcut(keyCombo: Settings.shared.areaCaptureShortcut, action: {
            ScreenshotManager.shared.startCapture(mode: .area)
        })
        registerShortcut(keyCombo: Settings.shared.fullScreenCaptureShortcut, action: {
            ScreenshotManager.shared.startCapture(mode: .fullScreen)
        })
        registerShortcut(keyCombo: Settings.shared.windowCaptureShortcut, action: {
            ScreenshotManager.shared.startCapture(mode: .window)
        })
        registerShortcut(keyCombo: Settings.shared.delayCaptureShortcut, action: {
            ScreenshotManager.shared.startCapture(mode: .delay)
        })
    }
    
    func unregisterAllShortcuts() {
        for (_, hotKeyRef) in eventHotKey {
            UnregisterEventHotKey(hotKeyRef)
        }
        eventHotKey.removeAll()
        callbackMap.removeAll()
        hotKeyIDs.removeAll()
    }
    
    private func registerShortcut(keyCombo: String, action: @escaping () -> Void) {
        // 简化实现，后续完善快捷键解析
        let hotKeyID = nextHotKeyID
        nextHotKeyID += 1
        callbackMap[hotKeyID] = action
        hotKeyIDs[keyCombo] = hotKeyID
    }
}
