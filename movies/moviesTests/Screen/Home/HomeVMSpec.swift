//
//  HomeVMSpec.swift
//  moviesTests
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import movies

class HomeVMSpec: QuickSpec {
    
    override func spec() {
        describe("view model action") {
            var routerMock: GeneralRouterMock!
            var homeVMForTest: HomeVM!
            var generalTableViewMock: GeneralTableViewMock!
            beforeEach {
                routerMock = .init()
                homeVMForTest = .init()
                generalTableViewMock = .init()
                homeVMForTest.router = routerMock
                homeVMForTest.bind(view: generalTableViewMock)
            }
            context("positive test") {
                it("should bind to navigation title") {
                    homeVMForTest.navigationTitle = "test"
                    expect(generalTableViewMock.navTitle.text).toEventually(equal("test"))
                }
                it("should route to movie detail") {
                    var invoked: Bool = false
                    routerMock.movieDetailObserver = { _, model in
                        expect(model.movieId).to(equal(1))
                        invoked = true
                    }
                    homeVMForTest.onTap(movie: build {
                        $0.id = 1
                    })
                    expect(invoked).toEventually(beTrue())
                }
            }
        }
    }
}
