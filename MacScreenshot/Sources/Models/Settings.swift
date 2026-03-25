//
//  Settings.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Foundation

class Settings: NSObject {
    static let shared = Settings()
    
    // MARK: - 快捷键
    var areaCaptureShortcut: String = "Cmd+Shift+A"
    var fullScreenCaptureShortcut: String = "Cmd+Shift+F"
    var windowCaptureShortcut: String = "Cmd+Shift+W"
    var delayCaptureShortcut: String = "Cmd+Shift+D"
    
    // MARK: - 默认设置
    var defaultDelaySeconds: Double = 3.0
    var defaultAnnotationColor: String = "#FF3B30" // 红色
    var defaultLineWidth: CGFloat = 3.0
    
    // MARK: - 导出设置
    var autoCopyToClipboard: Bool = true
    var autoSaveToFile: Bool = false
    var defaultSaveDirectory: URL?
    
    // MARK: - 应用设置
    var launchAtLogin: Bool = false
    var showInDock: Bool = false
    
    private override init() {
        super.init()
        loadSettings()
    }
    
    func loadSettings() {
        // 从UserDefaults加载
        let defaults = UserDefaults.standard
        areaCaptureShortcut = defaults.string(forKey: "areaCaptureShortcut") ?? areaCaptureShortcut
        fullScreenCaptureShortcut = defaults.string(forKey: "fullScreenCaptureShortcut") ?? fullScreenCaptureShortcut
        defaultDelaySeconds = defaults.double(forKey: "defaultDelaySeconds) == 0 ? defaultDelaySeconds : defaults.double(forKey: "defaultDelaySeconds")
        autoCopyToClipboard = defaults.bool(forKey: "autoCopyToClipboard")
        autoSaveToFile = defaults.bool(forKey: "autoSaveToFile")
        launchAtLogin = defaults.bool(forKey: "launchAtLogin")
        showInDock = defaults.bool(forKey: "showInDock")
    }
    
    func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(areaCaptureShortcut, forKey: "areaCaptureShortcut")
        defaults.set(fullScreenCaptureShortcut, forKey: "fullScreenCaptureShortcut")
        defaults.set(defaultDelaySeconds, forKey: "defaultDelaySeconds")
        defaults.set(autoCopyToClipboard, forKey: "autoCopyToClipboard")
        defaults.set(autoSaveToFile, forKey: "autoSaveToFile")
        defaults.set(launchAtLogin, forKey: "launchAtLogin")
        defaults.set(showInDock, forKey: "showInDock")
        defaults.synchronize()
    }
}
