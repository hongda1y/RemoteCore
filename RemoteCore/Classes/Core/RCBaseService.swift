//
//  RCBaseService.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation
import Alamofire

private protocol RCBaseServiceRepo {

    /// Fetch Items
    /// - Parameters:
    ///   - withUrl: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - debug: Debug response from request
    ///   - completion: Callback when request complete
    func fetchItems<T:Codable>(with url : String,
                               params : Parameters?,
                               headers : HTTPHeaders?,
                               debug: Bool,
                               completion : @escaping RCResposeHandler<T>)


    /// Add Item
    /// - Parameters:
    ///   - item: Item or Object
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - debug: Debug response from request
    ///   - completion: Callback when request complete
    func addItem<T:Codable>(_ item : T,
                            with url : String,
                            parameters : Parameters?,
                            headers : HTTPHeaders?,
                            debug: Bool,
                            completion : @escaping RCResposeHandler<T>)


    /// Update Item
    /// - Parameters:
    ///   - item: Item or Object
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - debug: Debug response from request
    ///   - completion: Callback when request complete
    func updateItem<T:Codable>(_ item : T,
                               with url : String,
                               parameters : Parameters?,
                               headers : HTTPHeaders?,
                               debug: Bool,
                               completion : @escaping RCResposeHandler<T>)


    /// Update Item
    /// - Parameters:
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - debug: Debug response from request
    ///   - completion: Callback when request complete
    func deleteItem(with url : String,
                    parameters : Parameters?,
                    headers : HTTPHeaders?,
                    debug: Bool,
                    completion : @escaping RCResposeHandler<RCDeleteResponse>)




    /// Upload Image
    /// - Parameters:
    ///   - type: Object type of response of request
    ///   - imageKey: Key for upload image
    ///   - imageData: Image Data
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - debug: Debug response from request
    ///   - completion: Callback when request complete
    func uploadImage<T:Codable>(of type : T.Type,
                                imageKey : String,
                                imageData : Data?,
                                with url : String,
                                parameters : Parameters?,
                                headers : HTTPHeaders?,
                                debug: Bool,
                                completion : @escaping RCResposeHandler<T>)


    /// Search Item
    /// - Parameters:
    ///   - type: Object type of response of request
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - debug: Debug response from request
    ///   - completion: Callback when request complete
    func searchItems<T:Codable>(of type : T.Type,
                                url : String,
                                parameters : Parameters?,
                                headers : HTTPHeaders?,
                                debug: Bool,
                                completion : @escaping RCResposeHandler<T>)


}


open class RCBaseService {

    /// rcRemote : Remote Object
    public let rcRemote = RCRemote()


}


extension RCBaseService : RCBaseServiceRepo {


    /// Fetch Items
    /// - Parameters:
    ///   - withUrl: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - completion: Callback when request complete
    public func fetchItems<T>(with url: String,
                       params: Parameters?,
                       headers: HTTPHeaders?,
                       debug: Bool = false,
                       completion: @escaping RCResposeHandler<T>) where T : Decodable, T : Encodable {

        let configure : RCConfigure<T> = .init(url: url,
                                               method: .get,
                                               params: params,
                                               headers: headers,
                                               debug: debug,
                                               completion:completion)
        rcRemote.request(configuration: configure)
        

    }


    /// Add Item
    /// - Parameters:
    ///   - item: Item or Object
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - completion: Callback when request complete
    public func addItem<T>(_ item: T,
                    with url: String,
                    parameters: Parameters?,
                    headers: HTTPHeaders?,
                    debug: Bool = false,
                    completion: @escaping RCResposeHandler<T>) where T : Decodable, T : Encodable {

        guard let headers = headers else {
            completion(.failure(.customError(.missing_header)))
            return
        }

        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(item)
        guard let jData = jsonData else {
            completion(.failure(.customError(.json_response_error)))
            return
        }

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.headers = headers
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.httpBody = jData

        let configure : RCURLRequestConfigure<T> = .init(urlRequest: urlRequest, debug: debug,completion: completion)
        
        rcRemote.request(configuration: configure)

    }




    /// Update Item
    /// - Parameters:
    ///   - item: Item or Object
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - completion: Callback when request complete
    public func updateItem<T>(_ item: T,
                       with url: String,
                       parameters: Parameters?,
                       headers: HTTPHeaders?,
                       debug: Bool = false,
                       completion: @escaping RCResposeHandler<T>) where T : Decodable, T : Encodable {

        guard let headers = headers else {
            completion(.failure(.customError(.missing_header)))
            return
        }

        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(item)
        guard let jData = jsonData else {
            completion(.failure(.customError(.json_response_error)))
            return
        }

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.headers = headers
        urlRequest.httpMethod = HTTPMethod.patch.rawValue
        urlRequest.httpBody = jData

        let configure : RCURLRequestConfigure<T> = .init(urlRequest: urlRequest, debug: debug,completion: completion)

        rcRemote.request(configuration: configure)

    }


    /// Update Item
    /// - Parameters:
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - completion: Callback when request complete
    public func deleteItem(with url: String,
                    parameters: Parameters?,
                    headers: HTTPHeaders?,
                    debug: Bool = false,
                    completion: @escaping RCResposeHandler<RCDeleteResponse>) {

        let configure : RCConfigure<RCDeleteResponse> = .init(url: url,
                                                   method: .delete,
                                                   params: parameters,
                                                   headers: headers,
                                                   debug: debug,
                                                   completion: completion)

        rcRemote.request(configuration: configure)

    }


    /// Upload Image
    /// - Parameters:
    ///   - type: Object type of response of request
    ///   - imageKey: Key for upload image
    ///   - imageData: Image Data
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - completion: Callback when request complete
    public func uploadImage<T>(of type: T.Type,
                        imageKey: String,
                        imageData: Data?,
                        with url: String,
                        parameters: Parameters?,
                        headers: HTTPHeaders?,
                        debug: Bool = false,
                        completion: @escaping RCResposeHandler<T>) where T : Decodable, T : Encodable {

        let configure : RCConfigure<T> = .init(url:url,
                                                   method: .get,
                                                   params: parameters,
                                                   headers: headers,
                                                   file: .init(data:imageData,fileUploadKey: imageKey),
                                                   debug: debug,
                                               completion: completion)

        rcRemote.uploadFile(configuration: configure)

    }



    /// Search Item
    /// - Parameters:
    ///   - type: Object type of response of request
    ///   - query: Search query
    ///   - url: Request url
    ///   - params: Request parameters
    ///   - headers: Request headers
    ///   - completion: Callback when request complete
    public func searchItems<T>(of type: T.Type,
                        url: String,
                        parameters: Parameters?,
                        headers: HTTPHeaders?,
                        debug: Bool = false,
                        completion: @escaping RCResposeHandler<T>) where T : Decodable, T : Encodable {

        let configure : RCConfigure<T> = .init(url: url,
                                               method: .get,
                                               params: parameters,
                                               headers: headers,
                                               debug: debug,
                                               completion: completion)
        rcRemote.request(configuration: configure)

    }
}
