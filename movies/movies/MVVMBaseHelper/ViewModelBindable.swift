//
//  ViewModelBindable.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

public protocol Bindable {
    func bind()
}

@propertyWrapper
public class ViewModelBindable<Wrapped>: Bindable {
    public var projectedValue: ViewModelBinder<Wrapped>
    public var wrappedValue: Wrapped {
        didSet {
            let newValue = wrappedValue
            let binder = projectedValue
            runOnMainThread {
                binder.signalSubscriber(with: newValue, old: oldValue)
            }
        }
    }
    
    public init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
        self.projectedValue = .init()
    }

    public func bind() {
        self.projectedValue.forceSignalSubscriber(with: wrappedValue)
    }
    
}

// MARK: Binder

public class ViewModelBinder<Observed> {
    public typealias Binder = (Observed) -> Void
    public typealias Comparator = (Observed, Observed) -> Bool
    private var subscriber: Binder?
    private var comparator: Comparator?
    private var pending: Observed? = nil
    
    @discardableResult
    public func whenSet<V: UIView>(_ view: V, then: @escaping (V, Observed) -> Void) -> Self {
        subscriber = { [weak view = view] observed in
            guard let view = view else { return }
            then(view, observed)
        }
        if let pending = self.pending {
            forceSignalSubscriber(with: pending)
        }
        return self
    }
    
    @discardableResult
    public func whenCompare(then: @escaping Comparator) -> Self {
        self.comparator = then
        return self
    }
    
    func signalSubscriber(with newObserved: Observed, old oldObserved: Observed) {
        guard !(comparator?(newObserved, oldObserved) ?? true) else { return }
        forceSignalSubscriber(with: newObserved)
    }
    
    func forceSignalSubscriber(with observed: Observed) {
        guard let subscriber = self.subscriber else {
            pending = observed
            return
        }
        pending = nil
        runOnMainThread {
            subscriber(observed)
        }
    }
}

public extension ViewModelBinder where Observed: Equatable {
    @discardableResult
    func equalComparation() -> Self {
        return whenCompare { $0 == $1 }
    }
}

public extension ViewModelBinder where Observed: AnyObject {
    @discardableResult
    func referenceComparation() -> Self {
        return whenCompare { $0 === $1 }
    }
}
