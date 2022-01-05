//
//  RemoteConfig.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation
import Alamofire


public struct RCFile{
    var fileName : String = "\(Date().timeIntervalSince1970)"
    var fileURL : URL?
    var data : Data?
    var mimeType : String = "image/jpg"
    var fileUploadKey : String?
}

public struct RemoteConfigure<T:Codable> {
    
    /// url : Remote Api Url
    var url         : String
    
    /// method : Request Method , Default value : .get
    var method      : HTTPMethod    = .get
    
    /// params : Request Parameters , Default value : nil
    var params      : Parameters?   = nil
    
    /// headers :  Request Header , Default value : nil
    var headers     : HTTPHeaders?  = nil
    
    /// fileKey : Request key paramater for upload file , Default value : nil
    var fileKey     : String?       = nil
    
    /// fileData : Data that upload to server , Default value : nil
    var fileData    : Data?       = nil
    
    /// timeout  : Request timeout , Default value 60s
    var timeout     : TimeInterval  = .init(60)
    
    /// debug   : Debug response from request , Default value false
    var debug       : Bool          = false
    
    /// completion : Response handler when request complete , Default value :  empty callback
    var completion  : (Swift.Result<T?,RemoteError>) -> Void = {_ in}
    
}


public struct RemoteURLRequestConfigure<T:Codable> {
    
    /// urlRequest : Use URLRequest  instead of url string
    var urlRequest  : URLRequest
    
    /// debug   : Debug response from request , Default value false
    var debug       : Bool = false
    
    /// completion : Response handler when request complete , Default value : empty callback
    var completion  : (Swift.Result<T?,RemoteError>) -> Void = {_ in}
}


public struct ResponseConfigure<T:Codable> {
   
    /// response : Response for request
    var response    : DataResponse<Data, AFError>
    
    /// method     : Request method for checking request response
    var method      : HTTPMethod = .get
    
    /// completion : Response handler when request complete , Default value :  empty callback
    var completion  : (Swift.Result<T?,RemoteError>) -> Void = {_ in}
}
