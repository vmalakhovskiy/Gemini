//
//  ViewModel.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/10/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

// MARK: Protocol

protocol ViewModel {
    var comparingDirectoryPath: MutableProperty<String> { get }
    var comparableDirectoryPath: MutableProperty<String> { get }
    var compareAction: Action<(), Bool, NoError> { get }
}

// MARK: Implementation

class ViewModelImpl: ViewModel {
    private let model: Model
    private let (cancelSignal, cancelObserver) = Signal<(), NoError>.pipe()

    let comparingDirectoryPath = MutableProperty("")
    let comparableDirectoryPath = MutableProperty("")

    lazy var compareAction: Action<(), Bool, NoError> = { [weak self] in
        guard let strongSelf = self else { return .empty() }

        let enabledIf = MutableProperty(false)
        enabledIf <~ combineLatest(strongSelf.comparingDirectoryPath.producer, strongSelf.comparableDirectoryPath.producer)
            .map { strongSelf.model.verifyPath($0) && strongSelf.model.verifyPath($1) }

        return Action(enabledIf: enabledIf) { [weak self] in
            guard let strongSelf = self else { return .empty }

            return strongSelf.model.compareDirectoriesWithPaths(strongSelf.comparingDirectoryPath.value,
                comparable: strongSelf.comparableDirectoryPath.value)
                .takeUntil(strongSelf.cancelSignal)
        }
    }()

    init(model: Model) {
        self.model = model

        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyDownMask) { event -> NSEvent? in
            if event.keyCode == 53 {
                self.cancelObserver.sendNext()
            }
            NSApp.activateIgnoringOtherApps(true)
            return event
        }
    }

    deinit {
        cancelObserver.sendCompleted()
    }
}

// MARK: Factory

class ViewModelFactory {
    static func defaultViewModel() -> ViewModel {
        return ViewModelImpl(model: ModelFactory.defaultModel())
    }
}
