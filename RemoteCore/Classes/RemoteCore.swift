//
//  Remote.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import UIKit
import Alamofire

private protocol RemoteCoreDelegate {
    
    /// Request
    ///    - Parameters :
    ///     - configure : Defualt Remote Configuration
    func request<T:Codable>(configuration : RemoteConfigure<T>)
    
    
    /// Request
    ///    - Parameters :
    ///     - configure : UrlRequest Remote Configuration
    func request<T:Codable>(configuration : RemoteURLRequestConfigure<T>)
    
    
    
    /// Decode Object
    ///    - Parameters :
    ///     - data : Json data from request
    func decodeObject<T:Codable>(_ data : Data?) -> T?
    
    
    /// Upload File
    ///    - Parameters :
    ///     - configure : Default Remote Configuration
    func uploadFile<T:Codable>(configuration : RemoteConfigure<T>)
    
    
}


extension RemoteCore : RemoteCoreDelegate {
    
    
    /// Request
    ///     - Parameters :
    ///      - configure : Defualt Remote Configuration
    public func request<T>(configuration: RemoteConfigure<T>) where T : Decodable, T : Encodable {
        
        guard let headers = configuration.headers else {
            configuration.completion(.failure(.csError(.missing_header)))
            return
        }
        
        AF.sessionConfiguration.timeoutIntervalForRequest = configuration.timeout
        AF.sessionConfiguration.timeoutIntervalForResource = configuration.timeout
        
       
        
        AF.request(configuration.url,
                   method: configuration.method,
                   parameters: configuration.params,
                   headers: headers)
            .responseData { response in
                self.responseHandler(configuration: .init(response: response,
                                                          method: configuration.method,
                                                          completion: { result in
                    configuration.completion(result)
                }))
            }
    }
    
    
    /// Request
    ///    - Parameters :
    ///     - configure : UrlRequest Remote Configuration
    public func request<T>(configuration: RemoteURLRequestConfigure<T>) where T : Decodable, T : Encodable {
        
        AF.request(configuration.urlRequest)
            .responseData { response in
                self.responseHandler(configuration: .init(response: response,
                                                          method: configuration.urlRequest.method ?? .get,
                                                          completion: { result in
                    configuration.completion(result)
                }))
            }
    }
    
    
    /// Upload File
    ///    - Parameters :
    ///      - configure : Default Remote Configuration
    public func uploadFile<T>(configuration: RemoteConfigure<T>) where T : Decodable, T : Encodable {
        
        guard let headers = configuration.headers else {
            configuration.completion(.failure(.csError(.missing_header)))
            return
        }
        
        AF.sessionConfiguration.timeoutIntervalForRequest = configuration.timeout
        AF.sessionConfiguration.timeoutIntervalForResource = configuration.timeout
        
        
        let fileName = "\(Date().timeIntervalSince1970)"
        guard let data = configuration.fileData , let dataKey = configuration.fileKey else {
            configuration.completion(.failure(.csError(.missing_file)))
            return
        }
        
        AF.upload(multipartFormData: {  multipartFormData in
            
            multipartFormData.append(data, withName: dataKey, fileName: fileName, mimeType: "image/jpg")
            
            if let params = configuration.params {
                for (key, value) in params {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, to: configuration.url,
                  method: configuration.method,
                  headers: headers)
            .responseData { result in
                if let object : T = self.decodeObject(result.data) {
                    configuration.completion(.success(object))
                }else {
                    configuration.completion(.failure(.csError(.upload_failed)))
                }
            }
    }
    
}


extension RemoteCore {
    
    /// responseHandler
    ///    - Parameters :
    ///     - configure : Default Response Configuration
    private func responseHandler<T:Codable>(configuration:ResponseConfigure<T>) {
        let response = configuration.response
        let statusCode = response.response?.statusCode ?? 500
        switch response.result {
        case .success(_ ):
            let object : T? = self.decodeObject(response.data)
            if configuration.method == .delete {
                configuration.completion(.success(object))
                return
            }
            switch statusCode {
            case 200..<300:
                configuration.completion(.success(object))
                break
            case 400..<403:
                let errMessage : ErrorResponse? = self.decodeObject(response.data)
                configuration.completion(.failure(.badRequest(errMessage?.message ?? "Bad Request")))
                break
            case 403:
                configuration.completion(.failure(.csError(.token_expired)))
                break
            case 500:
                configuration.completion(.failure(.csError(.something_went_wrong)))
                break
            default:
                configuration.completion(.failure(.csError(.json_response_error)))
                break
            }
            break
            
        case .failure(let err):
            
            if statusCode == 500 {
                configuration.completion(.failure(.csError(.something_went_wrong)))
            }
            
            else if statusCode == 403 {
                configuration.completion(.failure(.csError(.token_expired)))
            }
            
            else {
                configuration.completion(.failure(.error(err)))
            }
            break
        }
    }
}

class RemoteCore  {
        
    /// Decode Object
    ///     - Parameters :
    ///      - data : Json data from request
    public func decodeObject <T:Codable> (_ data: Data?) -> T? {
        
        guard let data = data else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: data)
            return object
            
        } catch let err {
            debugPrint(#function,"decode_error",err)
        }
        
        return nil
    
    }
}
