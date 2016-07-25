//
//  FolderPickerImageView.swift
//  Gemini
//
//  Created by Vitaliy Malakhovskiy on 7/25/16.
//  Copyright © 2016 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import Cocoa
import ReactiveCocoa
import Result

class FolderPickerImageView: NSImageView {

    private var fileTypeIsOk = false
    private var mDroppedFilePath = MutableProperty<String?>(nil)
    var droppedFilePath: AnyProperty<String?> {
        return AnyProperty(mDroppedFilePath)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType, NSPasteboardTypeTIFF])

        droppedFilePath.producer
            .takeUntil(rac_willDeallocSignalProducer())
            .map { $0 == nil }
            .startWithNext { [weak self] in
                self?.alphaValue = $0 ? 0.3 : 1
        }
    }

    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        fileTypeIsOk = checkExtension(sender)
        return dragOperation(sender)
    }

    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        return dragOperation(sender)
    }

    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        if let path = draggedFilePath(sender) {
            mDroppedFilePath.value = path
            return true
        }
        return false
    }

    func checkExtension(drag: NSDraggingInfo) -> Bool {
        if let filePath = draggedFilePath(drag), path = NSURL(fileURLWithPath: filePath).path {
            return NSFileManager.defaultManager().isDirectoryAtPath(path)
        }
        return false
    }

    private func draggedFilePath(sender: NSDraggingInfo) -> String? {
        guard let
            board = sender.draggingPasteboard().propertyListForType(NSFilenamesPboardType) as? [String],
            path = board.first
            else {
                return nil
            }
        return path
    }

    private func dragOperation(draggingInfo: NSDraggingInfo) -> NSDragOperation {
        return fileTypeIsOk ? .Copy : .None
    }
}