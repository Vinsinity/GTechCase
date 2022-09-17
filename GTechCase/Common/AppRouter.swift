//
//  AppRouter.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import UIKit

final class AppRouter { 
    
    func start(window: UIWindow?) {
        let viewController = HomeBuilder.make()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible() 
    }
}
