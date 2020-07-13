//
//  Presenter.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

public class ViewPresenter<View: AnyObject, Interactor, Router> {
    weak var view: View? {
        didSet {
            setup(view: view)
        }
    }
    var interactor: Interactor {
        didSet {
            setup(interactor: interactor)
        }
    }
    var router: Router
    
    init(with view: View, interactor: Interactor, router: Router) {
        self.view = view
        self.interactor = interactor
        self.router = router
        setup(view: view)
        setup(interactor: interactor)
    }
    
    open func setup(interactor: Interactor) { }
    
    open func setup(view: View?)  { }
}

class VCPresenter<View: UIViewController, Interactor, Router>: ViewPresenter<View, Interactor, Router> {
    
    public override init(with view: View, interactor: Interactor, router: Router) {
        super.init(with: view, interactor: interactor, router: router)
    }
    
    open override func setup(interactor: Interactor) { }
    
    open override func setup(view: View?)  { }
}
