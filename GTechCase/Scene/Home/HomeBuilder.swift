//
//  HomeBuilder.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import Foundation

final class HomeBuilder {
    
    static func make() -> HomeViewController {
        
        let viewController = HomeViewController()
        viewController.viewModel = HomeViewModel(service: app.service)
        return viewController
    }
    
}
