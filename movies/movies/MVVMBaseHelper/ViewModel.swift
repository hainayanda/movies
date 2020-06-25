//
//  ViewModel.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

open class ViewModel<View>: NSObject, Initiable {
    
    required public override init() {
        super.init()
        bindToModelRepositories()
        updateModel()
    }
    
    public func bindThenUpdate(view: View) {
        bind(view: view)
        bindToModelRepositories()
        updateView()
        updateModel()
        rebindModel()
    }
    
    open func bind(view: View) { }
    open func bindToModelRepositories() { }
    
    private var bindables: [Bindable] {
        let reflection = Mirror(reflecting: self)
        return reflection.children.compactMap {
            return $0.value as? Bindable
        }
    }
    
    private var modelRepositories: [ModelRepo] {
        let reflection = Mirror(reflecting: self)
        return reflection.children.compactMap {
            return $0.value as? ModelRepo
        }
    }
    
    open func rebindModel() {
        for repo in modelRepositories {
            repo.signalWithExisting()
        }
    }
    
    open func updateModel() { }
    
    func updateView() {
        for bindable in bindables {
            bindable.bind()
        }
    }
}

open class ScreenViewModel<View: UIViewController>: ViewModel<View> {
    weak var view: View?
    
    open override func bind(view: View) {
        self.view = view
    }
}

protocol ModelRepo {
    func signalWithExisting()
}

open class ModelRepository<Model, Param>: ModelRepo {
    public typealias SuccessAction = (Model) -> Void
    public typealias FailedAction = (Error) -> Void
    
    private var successAction: SuccessAction?
    private var failedAction: FailedAction?
    
    public var currentModel: Model?
    
    open func getModel(byParam param: Param) { }
    
    public init() { }
    
    @discardableResult
    public func whenSuccess(then: @escaping SuccessAction) -> Self {
        successAction = then
        return self
    }
    
    @discardableResult
    public func whenFailed(then: @escaping FailedAction) -> Self {
        failedAction = then
        return self
    }
    
    public func signalWithExisting() {
        guard let model = currentModel else {
            return
        }
        signalSuccess(with: model)
    }
    
    public func signalSuccess(with model: Model) {
        runOnMainThread {
            self.successAction?(model)
        }
    }
    
    public func signalError(with error: Error) {
        runOnMainThread {
            self.failedAction?(error)
        }
    }
}

public extension ModelRepository where Param == Void {
    func getModel() {
        self.getModel(byParam: ())
    }
}
