//
//  Service.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import Foundation
import Alamofire

struct ServiceResult<T> {
    let response: T?
    let error: Error?
}

struct Service {
    
    static let shared = Service()
    
    func request<T:Codable>(endpoint url: String, model: T.Type, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, completion: @escaping (ServiceResult<T>) -> ()) {
        do{
            let urlConvertible = try Router.shared.generateUrl(endpoint: url, method: method, parameters: parameters, encoding: encoding) 
            AF.request(urlConvertible).responseDecodable(of: model.self, completionHandler: {
                response in
                switch response.result {
                case .success(let model):
                    completion(ServiceResult(response: model, error: nil))
                case .failure(let error):
                    completion(ServiceResult(response: nil, error: error))
                }
            })
        }catch let urlRequestError{
            completion(ServiceResult(response: nil, error: urlRequestError))
        }
    }
    
}
