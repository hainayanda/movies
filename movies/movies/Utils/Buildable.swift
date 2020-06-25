//
//  Buildable.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public protocol Initiable: class {
    init()
}

public func build<Buildable: Initiable>(_ builder: (Buildable) -> Void) -> Buildable {
    let buildable = Buildable()
    builder(buildable)
    return buildable
}

public func build<Buildable: JSONAble>(_ builder: (inout Buildable) -> Void) -> Buildable {
    var buildable = Buildable()
    builder(&buildable)
    return buildable
}
