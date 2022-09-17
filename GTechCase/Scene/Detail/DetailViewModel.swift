//
//  DetailViewModel.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    func load()
}

enum DetailViewModelOutput: Equatable {
    case showDetail(item: SearchResponse)
    case updateTitle(title: String)
}

protocol DetailViewModelDelegate {
    func handleViewModelOutput(_ output: DetailViewModelOutput) 
}

final class DetailViewModel: DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate?
    private let item: SearchResponse
    
    init(item: SearchResponse){
        self.item = item
    }
    
    func load() {
        notify(.updateTitle(title: self.item.collectionName ?? ""))
        notify(.showDetail(item: item))
    }
    
    private func notify(_ output: DetailViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
    
    
}
