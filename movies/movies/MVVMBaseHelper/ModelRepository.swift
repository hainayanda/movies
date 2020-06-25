//
//  ModelRepository.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

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
