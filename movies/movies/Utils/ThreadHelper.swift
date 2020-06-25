//
//  ThreadHelper.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

/// Method to run on main thread
/// This method chcek the thread
/// If the current thread is main thread, then the closure would be run synchronously
public func runOnMainThread(_ closure: @escaping () -> Void) {
    guard !Thread.isMainThread else {
        closure()
        return
    }
    DispatchQueue.main.async(execute: closure)
}


public func dispatchOnMainThread(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}

public func dispatchOnMainThread(after deadline: DispatchTime, _ closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: deadline, execute: closure)
}
