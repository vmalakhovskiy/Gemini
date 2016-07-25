//
//  Model.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/10/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.

import Foundation
import ReactiveCocoa
import Result

// MARK: Protocol

protocol Model {
    func compareDirectoriesWithPaths(comparing: String, comparable: String) -> SignalProducer<Bool, NoError>
    func verifyPath(path: String) -> Bool
}

// MARK: Implementation

class ModelImpl: Model {
    private let geminiManager: GeminiManager
    private let fileManager: NSFileManager

    init(geminiManager: GeminiManager, fileManager: NSFileManager) {
        self.geminiManager = geminiManager
        self.fileManager = fileManager
    }

    func compareDirectoriesWithPaths(comparing: String, comparable: String) -> SignalProducer<Bool, NoError> {
        return geminiManager.compareDirectoriesWithPaths(comparing, comparable: comparable)
    }

    func verifyPath(path: String) -> Bool {
        return fileManager.isDirectoryAtPath(path)
    }
}

// MARK: Factory

class ModelFactory {
    static func defaultModel() -> Model {
        return ModelImpl(
            geminiManager: GeminiManagerFactory.defaultManagerWithIgnoreList(["*.DS_Store"]),
            fileManager: NSFileManager.defaultManager()
        )
    }
}