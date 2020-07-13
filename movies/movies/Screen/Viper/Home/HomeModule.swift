//
//  HomeModule.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 14/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class HomeModule {
    static var shared: HomeModule = .init()
    func getHomeScreen() -> UIViewController {
        let home = HomeScreenView()
        let presenter = HomeScreenPresenter(
            with: home,
            interactor: HomeScreenInteractor(),
            router: HomeScreenRouter()
        )
        home.presenter = presenter
        return home
    }
}
