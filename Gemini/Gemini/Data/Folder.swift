//
//  Folder.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

struct Folder {
    let files: [String: String]   // [hash : name]
    let folders: [String: Folder] // [relativePath : folder]
}

func == (lhs: Folder, rhs: Folder) -> Bool {
    return Array(lhs.files.keys) == Array(rhs.files.keys)
        && lhs.folders == rhs.folders
}

extension Folder: Equatable {}