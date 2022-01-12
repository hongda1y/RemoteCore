//
//  RCDefaultService.swift
//  RemoteCore
//
//  Created by GBS Technology on 6/1/22.
//

import Foundation
import Alamofire

public protocol RCDefaultServiceRepo {
        
    /// Fetch Items
    /// - Parameters:
    ///   - config: Request parameters
    func fetchItems<T:Codable>(with config : RCParameterConfigure<T>)

    
    /// Add or Update Item
    /// - Parameters:
    ///   - config: Request parameters
    func addOrUpdateItem<T:Codable>(with config : RCParameterConfigure<T>)


    /// Delete Item
    /// - Parameters:
    ///   - config: Request parameters
    func deleteItem(with config : RCParameterConfigure<RCDeleteResponse>)


    /// Upload Image
    /// - Parameters:
    ///   - config: Request parameters
    func uploadImage<T:Codable>(with config : RCParameterConfigure<T>)


    /// Search Item
    /// - Parameters:
    ///   - config: Request parameters
    func searchItems<T:Codable>(with config : RCParameterConfigure<T>)
    
    
}


open class RCDefaultService {
    
    /// headers : Default  headers that use user auth token
    open var headers : HTTPHeaders {
        .init()
    }
    
    /// rcRemote : Remote Object
    public let rcRemote = RCRemote()
    
    
    public init() {}
    
}


extension RCDefaultService : RCDefaultServiceRepo {
   
    
    /// Fetch Items
    /// - Parameters:
    ///   - config: Request parameters
    public func fetchItems<T>(with config: RCParameterConfigure<T>) where T : Decodable, T : Encodable {
        
        let params      : Parameters = [
            "page"      : config.page,
            "page_size" : config.limit
        ]
        
        let configure : RCConfigure<T> = .init(url: config.url,
                                               method: .get,
                                               params: params,
                                               headers: headers,
                                               debug: config.debug) {
            config.completion($0)
        }
    
        rcRemote.request(configuration: configure)
        
    }
    
    
    /// Add or Update Item
    /// - Parameters:
    ///   - config: Request parameters
    public func addOrUpdateItem<T>(
                           with config: RCParameterConfigure<T>) where T : Decodable, T : Encodable {
    
        guard let item = config.item else {
            config.completion(.failure(.customError(.missing_field)))
            return
        }

        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(item)
        guard let jData = jsonData else {
            config.completion(.failure(.customError(.json_response_error)))
            return
        }

        var urlRequest = URLRequest(url: URL(string: config.url)!)
        urlRequest.headers = headers
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.httpBody = jData

        let configure : RCURLRequestConfigure<T> = .init(urlRequest: urlRequest,
                                                         debug: config.debug) {
            config.completion($0)
        }

        rcRemote.request(configuration: configure)
    }
    

    /// Delete Item
    /// - Parameters:
    ///   - config: Request parameters
    public func deleteItem(with config: RCParameterConfigure<RCDeleteResponse>) {
        
        guard let id = config.itemId else {
            config.completion(.failure(.customError(.missing_field)))
            return
        }
        
        let params      : Parameters = [
            "id"      : id,
        ]
        
        let configure : RCConfigure<RCDeleteResponse> =
            .init(url: config.url,
                  method: .delete,
                  params: params,
                  headers: headers,
                  debug: config.debug) {
                config.completion($0)

        }

        rcRemote.request(configuration: configure)
        
    }
    
    
    // Upload Image
    /// - Parameters:
    ///   - config: Request parameters
    public func uploadImage<T>(with config: RCParameterConfigure<T>) where T : Decodable, T : Encodable {
        

        
        let configure : RCConfigure<T> =
            .init(url: config.url,
                  method: .get,
                  headers: headers,
                  file: config.file,
                  debug: config.debug) {
                config.completion($0)

        }

        rcRemote.uploadFile(configuration: configure)
    }
    
    
    /// Search Item
    /// - Parameters:
    ///   - config: Request parameters
    public func searchItems<T>(with config: RCParameterConfigure<T>) where T : Decodable, T : Encodable {
        
    
        guard let query = config.query else {
            config.completion(.failure(.customError(.missing_field)))
            return
        }
        
        
        let params : Parameters = [
            "search" : query,
            "pagination" : config.pagination
        ]
        
        
        let configure : RCConfigure<T> =
            .init(url: config.url,
                  method: .get,
                  params: params,
                  headers: headers,
                  debug: config.debug) {
                config.completion($0)

        }
        
        rcRemote.request(configuration: configure)
    }
}
