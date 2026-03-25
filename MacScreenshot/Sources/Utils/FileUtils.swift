//
//  FileUtils.swift
//  MacScreenshot
//
//  Created by liangjunchen on 2025/03/26.
//  Copyright © 2025 liangjunchen. All rights reserved.
//

import Cocoa

class FileUtils: NSObject {
    static let shared = FileUtils()
    
    private override init() {
        super.init()
    }
    
    func saveImageToDefaultLocation(_ image: NSImage, completion: @escaping (Bool) -> Void) {
        guard let defaultDirectory = getDefaultSaveDirectory() else {
            completion(false)
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmmss"
        let fileName = "MacScreenshot-\(formatter.string(from: Date())).png"
        let fileURL = defaultDirectory.appendingPathComponent(fileName)
        
        saveImage(image, to: fileURL) { success in
            completion(success)
        }
    }
    
    private func getDefaultSaveDirectory() -> URL? {
        if let customPath = Settings.shared.defaultSaveDirectory {
            try? FileManager.default.createDirectory(at: customPath, withIntermediateDirectories: true)
            return customPath
        }
        
        // 默认保存到~/Pictures/MacScreenshot
        let picturesURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first
        return picturesURL?.appendingPathComponent("MacScreenshot")
    }
    
    private func saveImage(_ image: NSImage, to url: URL, completion: @escaping (Bool) -> Void) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil) else {
            completion(false)
            return
        }
        
        let rep = NSBitmapImageRep(cgImage: cgImage)
        rep.size = image.size
        if let data = rep.representation(using: .png, properties: [:]) {
            do {
                try data.write(to: url)
                completion(true)
            } catch {
                completion(false)
            }
        } else {
            completion(false)
        }
    }
}
