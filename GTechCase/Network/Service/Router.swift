//
//  Router.swift
//  GTechCase
//
//  Created by Erhan on 15.09.2022.
//

import Foundation
import Alamofire

struct Router {
     
    static let shared = Router()
    
    private var baseUrl: URL {
        URL(string: "https://itunes.apple.com/")!
    }
    
    public func generateUrl(endpoint: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default) throws -> URLRequest {
        
        var request = URLRequest(url: baseUrl.appendingPathComponent(endpoint))
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return try encoding.encode(request, with: parameters)
    }
}
