//
//  ActionTypeExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension ActionType {
    static func empty() -> Action<Input, Output, Error> {
        return Action { _ in .empty }
    }
}