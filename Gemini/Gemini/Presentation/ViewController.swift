//
//  ViewController.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/10/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import Result

class ViewController: NSViewController {
    private let viewModel: ViewModel
    private let cocoaAction: CocoaAction

    @IBOutlet weak var xrayImageView: NSImageView!
    @IBOutlet weak var compareButton: NSButton!
    @IBOutlet weak var comparingImageView: FolderPickerImageView!
    @IBOutlet weak var comparableImageView: FolderPickerImageView!
    @IBOutlet weak var infoLabel: NSTextField!

    @IBOutlet weak var comparingViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var comparableViewTrailingConstraint: NSLayoutConstraint!

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.cocoaAction = CocoaAction(self.viewModel.compareAction, input: ())
        super.init(nibName: "ViewController", bundle: nil)! // Yes, i want to crash the app if nib not found
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCompareButton()
        setupBindings()
    }

    func setupCompareButton() {
        compareButton.target = cocoaAction
        compareButton.action = CocoaAction.selector
    }

    func setupBindings() {

        viewModel.comparingDirectoryPath <~ comparingImageView.droppedFilePath.producer.ignoreNil()
        viewModel.comparableDirectoryPath <~ comparableImageView.droppedFilePath.producer.ignoreNil()

        viewModel.compareAction.executing.producer
            .skip(1)
            .startWithNext { [weak self] executing in
                guard let strongSelf = self else { return }

                if executing {
                    strongSelf.infoLabel.stringValue = "Scanning..."

                    strongSelf.comparingViewLeadingConstraint.constant = CGRectGetWidth(strongSelf.view.frame) / 2 - CGRectGetWidth(strongSelf.comparingImageView.frame) / 2
                    strongSelf.comparableViewTrailingConstraint.constant = CGRectGetWidth(strongSelf.view.frame) / 2 - CGRectGetWidth(strongSelf.comparableImageView.frame) / 2

                    NSAnimationContext.runAnimationGroup({ context in
                        context.duration = 0.5
                        context.allowsImplicitAnimation = true
                        strongSelf.view.layoutSubtreeIfNeeded()
                        }, completionHandler: nil)

                    strongSelf.xrayImageView.addAnimationForKey(CAKeyframeAnimation.self, { xray in
                        xray.keyPath = "position.y"
                        xray.values = [0, CGRectGetHeight(strongSelf.view.frame) + CGRectGetHeight(strongSelf.xrayImageView.frame)]
                        xray.duration = 1
                        xray.beginTime = CACurrentMediaTime() + 0.5
                        xray.autoreverses = true
                        xray.additive = true
                        xray.repeatCount = FLT_MAX
                        xray.calculationMode = kCAAnimationPaced
                        xray.rotationMode = kCAAnimationRotateAuto
                        return "xray"
                    })

                } else {

                    strongSelf.infoLabel.stringValue = "Ready for scan"
                    strongSelf.xrayImageView.layer?.removeAnimationForKey("xray")

                    strongSelf.comparingViewLeadingConstraint.constant = 20
                    strongSelf.comparableViewTrailingConstraint.constant = 20

                    NSAnimationContext.runAnimationGroup({ context in
                        context.duration = 0.5
                        context.allowsImplicitAnimation = true
                        strongSelf.view.layoutSubtreeIfNeeded()
                        }, completionHandler: nil)
                }
        }

        viewModel.compareAction.enabled.producer
            .takeUntil(rac_willDeallocSignalProducer())
            .startWithNext { [weak self] in
                self?.compareButton.enabled = $0
        }

        viewModel.compareAction.values.observeNext { [weak self] equal in
            guard let strongSelf = self, window = strongSelf.view.window else { return }

            let alert = NSAlert()
            alert.addButtonWithTitle("OK")
            alert.messageText = "Finished"
            alert.informativeText = equal ? "Directories are equal" : "Directories are NOT equal"
            alert.icon = equal ? NSImage(named: "Success") : NSImage(named: "Failure")
            alert.alertStyle = .WarningAlertStyle
            alert.beginSheetModalForWindow(window, completionHandler: nil)
        }
    }
}

class ViewControllerFactory {
    static func defaultViewController() -> ViewController {
        return ViewController(viewModel: ViewModelFactory.defaultViewModel())
    }
}
