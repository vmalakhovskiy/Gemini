//
//  SignalProducerTypeExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

extension SignalProducerType {
    func ignoreValues() -> SignalProducer<(), Error> {
        return producer.map { _ in () }
    }

    func ignoreErrors() -> SignalProducer<Value, NoError> {
        return producer.flatMapError { _ in .empty }
    }
}