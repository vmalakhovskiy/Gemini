//
//  NSObjectExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

extension NSObject {
    func rac_willDeallocSignalProducer() -> SignalProducer<(), NoError> {
        return rac_willDeallocSignal()
            .toSignalProducer()
            .ignoreValues()
            .ignoreErrors()
    }
}