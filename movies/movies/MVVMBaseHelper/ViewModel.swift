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
