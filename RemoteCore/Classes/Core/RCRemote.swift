//
//  Remote.swift
//  RCRemote
//
//  Created by GBS Technology on 5/1/22.
//

import UIKit
import Alamofire

private protocol RCRemoteDelegate {
    
    /// Request
    ///    - Parameters :
    ///     - configure : Defualt Remote Configuration
    func request<T:Codable>(configuration : RCConfigure<T>)
    
    
    /// Request
    ///    - Parameters :
    ///     - configure : UrlRequest Remote Configuration
    func request<T:Codable>(configuration : RCURLRequestConfigure<T>)
    
    
    
    /// Decode Object
    ///    - Parameters :
    ///     - data : Json data from request
    func decodeObject<T:Codable>(_ data : Data?) -> T?
    
    
    /// Upload File
    ///    - Parameters :
    ///     - configure : Default Remote Configuration
    func uploadFile<T:Codable>(configuration : RCConfigure<T>)
    
    
}


extension RCRemote : RCRemoteDelegate {
    
    
    /// Request
    ///     - Parameters :
    ///      - configure : Defualt Remote Configuration
    public func request<T>(configuration: RCConfigure<T>) where T : Decodable, T : Encodable {
        
        guard let headers = configuration.headers else {
            configuration.completion(.failure(.customError(.missing_header)))
            return
        }
        
        AF.sessionConfiguration.timeoutIntervalForRequest = configuration.timeout
        AF.sessionConfiguration.timeoutIntervalForResource = configuration.timeout
        
       
        AF.request(configuration.url,
                   method: configuration.method,
                   parameters: configuration.params,
                   encoding: configuration.encoding,
                   headers: headers)
            .responseData { response in
                
                self.responseHandler(configuration: .init(response: response,
                                                          method: configuration.method,
                                                          debug:configuration.debug,
                                                          completion: configuration.completion))
            }
    }
    
    
    /// Request
    ///    - Parameters :
    ///     - configure : UrlRequest Remote Configuration
    public func request<T>(configuration: RCURLRequestConfigure<T>) where T : Decodable, T : Encodable {
        
        AF.request(configuration.urlRequest)
            .responseData { response in
                self.responseHandler(configuration: .init(response: response,
                                                          method: configuration.urlRequest.method ?? .get,
                                                          completion: configuration.completion))
            }
    }
    
    
    /// Upload File
    ///    - Parameters :
    ///      - configure : Default Remote Configuration
    public func uploadFile<T>(configuration: RCConfigure<T>) where T : Decodable, T : Encodable {
        
        guard let headers = configuration.headers else {
            configuration.completion(.failure(.customError(.missing_header)))
            return
        }
        
       
        guard let file = configuration.file,
              let data = file.data ,
              let dataKey = file.fileUploadKey else {
            configuration.completion(.failure(.customError(.missing_file)))
            return
        }
        let fileName = file.fileName
        let mimeType = file.mimeType

        AF.sessionConfiguration.timeoutIntervalForRequest = configuration.timeout
        AF.sessionConfiguration.timeoutIntervalForResource = configuration.timeout
        
        
        AF.upload(multipartFormData: {  multipartFormData in
            
            multipartFormData.append(data, withName: dataKey, fileName: fileName, mimeType: mimeType)
            
            if let params = configuration.params {
                for (key, value) in params {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, to: configuration.url,
                  method: configuration.method,
                  headers: headers)
            .responseData { result in
                
                if configuration.debug {
                    debugPrint(result.result)
                }
                
                if let object : T = self.decodeObject(result.data) {
                    configuration.completion(.success(object))
                }else {
                    configuration.completion(.failure(.customError(.upload_failed)))
                }
            }
    }
    
}


extension RCRemote {
    
    /// responseHandler
    ///    - Parameters :
    ///     - configure : Default Response Configuration
    private func responseHandler<T:Codable>(configuration:RCResponseConfigure<T>) {
        let response = configuration.response
        let statusCode = response.response?.statusCode ?? 500
        
        switch response.result {
        case .success(_ ):
            let object : T? = self.decodeObject(response.data)
            if configuration.debug , let obj = object{
                debugPrint(#function,obj)
            }
            if configuration.method == .delete {
                configuration.completion(.success(object))
                return
            }
            switch statusCode {
            case 200..<300:
                configuration.completion(.success(object))
                break
            case 400..<403:
                let errMessage : RCErrorResponse? = self.decodeObject(response.data)
                configuration.completion(.failure(.badRequest(errMessage?.message ?? "Bad Request")))
                break
            case 403:
                configuration.completion(.failure(.customError(.token_expired)))
                break
            case 500:
                configuration.completion(.failure(.customError(.something_went_wrong)))
                break
            default:
                configuration.completion(.failure(.customError(.json_response_error)))
                break
            }
            break
            
        case .failure(let err):
            
            if statusCode == 500 {
                configuration.completion(.failure(.customError(.something_went_wrong)))
            }
            
            else if statusCode == 403 {
                configuration.completion(.failure(.customError(.token_expired)))
            }
            
            else {
                configuration.completion(.failure(.error(err)))
            }
            break
        }
    }
}


public class RCRemote  {
        
    
    public init() {}
    
    
    
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
            
            if let jsonString = try? JSONSerialization.jsonObject(with: data,
                                                                  options: .allowFragments) {
                debugPrint(#function,"decode_error",jsonString)
            }else {
                debugPrint(#function,"decode_error", err)
            }
        }
        return nil
    
    }
}
