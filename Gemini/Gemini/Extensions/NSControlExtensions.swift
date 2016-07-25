//
//  NSControlExtensions.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import Cocoa

extension NSControl {
    func addAnimationForKey<T: CAAnimation>(type: T.Type, _ animation: T -> String?) {
        let anim = T()
        let key = animation(anim)
        layer?.addAnimation(anim, forKey: key)
    }
}