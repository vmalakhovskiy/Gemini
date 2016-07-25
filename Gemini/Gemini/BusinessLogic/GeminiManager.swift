//
//  GeminiManager.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/8/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

// MARK: Protocol

protocol GeminiManager {
    func compareDirectoriesWithPaths(comparing: String, comparable: String) -> SignalProducer<Bool, NoError>
}

// MARK: Implementation

class GeminiManagerImpl: GeminiManager {
    private let ignoreList: [String]
    private let fileManager: NSFileManager

    init(ignoreList: [String], fileManager: NSFileManager) {
        self.ignoreList = ignoreList
        self.fileManager = fileManager
    }

    func compareDirectoriesWithPaths(comparing: String, comparable: String) -> SignalProducer<Bool, NoError> {
        return SignalProducer(
            value: scanContentsOfDir(comparing, pathPrefix: comparing) == scanContentsOfDir(comparable, pathPrefix: comparable)
        ).delay(3, onScheduler: QueueScheduler.mainQueueScheduler)
    }

    private func scanContentsOfDir(path: String, pathPrefix: String) -> Folder {
        let contents = (try? fileManager.contentsOfDirectoryAtURL(NSURL(fileURLWithPath:path, isDirectory: true),
            includingPropertiesForKeys: nil,
            options: NSDirectoryEnumerationOptions(rawValue: 0))
        ) ?? []

        var folders = [String: Folder]()
        var files = [String: String]()

        for node in contents {
            if let nodePath = node.path {
                if fileManager.isDirectoryAtPath(nodePath) {
                    let relativePath = nodePath.stringByReplacingOccurrencesOfString(pathPrefix, withString: "")
                    folders[relativePath] = scanContentsOfDir(nodePath, pathPrefix: pathPrefix)
                } else {
                    if let
                        hash = fileManager.fileContentsChecksum(nodePath),
                        name = nodePath.componentsSeparatedByString("/").last
                            where !mentionedInIgnoreList(name) {
                                files[hash] = name
                    }
                }
            }
        }
        return Folder(files: files, folders: folders)
    }

    private func mentionedInIgnoreList(candidate: String) -> Bool {
        for rule in ignoreList {
            switch (rule.fileName(), rule.fileExtension()) {
            case let (.Some("*"), .Some(ext)) where ext == candidate.fileExtension(): return true
            case let (.Some(name), .Some("*")) where name == candidate.fileName(): return true
            case let (.Some(name), .Some(ext)) where name == candidate.fileName() && ext == candidate.fileExtension(): return true
            default: ()
            }
        }
        return false
    }
}

// MARK: Factory

class GeminiManagerFactory {
    static func defaultManagerWithIgnoreList(ignoreList: [String]) -> GeminiManager {
        return GeminiManagerImpl(
            ignoreList: ignoreList,
            fileManager: NSFileManager.defaultManager()
        )
    }
}
