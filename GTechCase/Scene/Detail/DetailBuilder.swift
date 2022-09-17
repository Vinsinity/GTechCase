//
//  DetailBuilder.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import Foundation

final class DetailBuilder {
    static func make(viewModel: DetailViewModelProtocol) -> DetailViewController {
        let viewController = DetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
