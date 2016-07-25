//
//  SignalTypeExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

extension SignalType {
    func ignoreValues() -> Signal<(), Error> {
        return signal.map { _ in () }
    }

    func ignoreErrors() -> Signal<Value, NoError> {
        return signal.flatMapError { _ in .empty }
    }
}