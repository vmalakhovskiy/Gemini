//
//  NSFileManagerExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

extension NSFileManager {
    func isDirectoryAtPath(path: String) -> Bool {
        var isDir : ObjCBool = false
        if fileExistsAtPath(path, isDirectory:&isDir) {
            if isDir {
                return true
            }
        }
        return false
    }

    func fileContentsChecksum(path: String) -> String? {
        return NSData(contentsOfFile: path)?.MD5().hexedString()
    }
}