//
//  AppDelegate.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/10/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let viewController = ViewControllerFactory.defaultViewController()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.contentView?.addSubview(viewController.view)
    }
}
