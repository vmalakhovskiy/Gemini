//
//  StringExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

extension String {
    func fileName() -> String? {
        return componentsSeparatedByString(".").first
    }

    func fileExtension() -> String? {
        return componentsSeparatedByString(".").last
    }
}