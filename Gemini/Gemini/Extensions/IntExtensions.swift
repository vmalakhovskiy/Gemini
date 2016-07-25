//
//  IntExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

extension Int {
    func hexedString() -> String {
        return NSString(format:"%02x", self) as String
    }
}