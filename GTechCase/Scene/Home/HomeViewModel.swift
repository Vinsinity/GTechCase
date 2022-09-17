//
//  HomeViewModel.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func load()
    func searchRequest(parameter: String, media: String)
    func selectItem(at index: Int)
}

enum HomeViewModelOutput {
    case setLoading(isLoading: Bool)
    case setError(error: String)
    case setTitle(title: String)
    case showList(list: [SearchResponse])
}

enum HomeViewModelRoute {
    case showDetail(DetailViewModelProtocol)
}

protocol HomeViewModelDelegate {
    func handleHomeViewModelOutput(_ output: HomeViewModelOutput)
    func navigate(route: HomeViewModelRoute)
}

class HomeViewModel: HomeViewModelProtocol {
    
    var delegate: HomeViewModelDelegate?
    private let service: Service
    private var searchResponse: [SearchResponse] = []
    
    init(service: Service) {
        self.service = service
    }
    
    func load() { 
        notify(.setTitle(title: "GTech Challenge")) 
    }
    
    func searchRequest(parameter: String, media: String) {
        notify(.setLoading(isLoading: true))
        let parameters = ["term": parameter,"media": media]
        service.request(endpoint: Endpoint.search.rawValue, model: SearchResult.self,parameters: parameters, completion: { [weak self]
            response in
            guard let self = self else {return}
            self.notify(.setLoading(isLoading: false))
            if response.error != nil {
                self.notify(.setError(error: response.error?.localizedDescription ?? "Service Error"))
                return
            }
            self.searchResponse = response.response?.results ?? []
            self.notify(.showList(list: self.searchResponse))
        })
    }
    
    func selectItem(at index: Int) {
        let item = self.searchResponse[index]
        let viewModel = DetailViewModel(item: item)
        delegate?.navigate(route: .showDetail(viewModel))
    }
    
    private func notify(_ output: HomeViewModelOutput) {
        delegate?.handleHomeViewModelOutput(output)
    }
    
}
