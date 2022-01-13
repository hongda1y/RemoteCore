//
//  RemoteConfig.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation
import Alamofire


public struct RCFile {
        
    
    /// fileName : File name
    var fileName : String = "\(Date().timeIntervalSince1970)"
    
    /// fileURL : File URL
    var fileURL : URL?
    
    /// data : File Data
    var data : Data?
    
    /// mimeType : File mimeType
    var mimeType : String = "image/jpg"
    
    /// mimeType : File key of server
    var fileUploadKey : String?
    
    
    /// Init
    /// - Parameters:
    ///   - fileName: File name
    ///   - fileURL: File url path
    ///   - data: File Data
    ///   - mimeType: File mimeType
    ///   - fileUploadKey: File key of server
    public init(fileName: String = "\(Date().timeIntervalSince1970)",
                fileURL: URL? = nil,
                data: Data? = nil,
                mimeType: String = "image/jpg",
                fileUploadKey: String? = nil) {
        self.fileName = fileName
        self.fileURL = fileURL
        self.data = data
        self.mimeType = mimeType
        self.fileUploadKey = fileUploadKey
    }
    
}


public struct RCConfigure<T:Codable> {
        
    
    /// url : Remote Api Url
    var url         : String
    
    /// method : Request Method , Default value : .get
    var method      : HTTPMethod    = .get
    
    /// params : Request Parameters , Default value : nil
    var params      : Parameters?   = nil
    
    /// headers :  Request Header , Default value : nil
    var headers     : HTTPHeaders?  = nil
    
    /// file : File for upload, Default value : nil
    var file        : RCFile? = nil
    
    /// timeout  : Request timeout , Default value 60s
    var timeout     : TimeInterval  = .init(60)
    
    /// debug   : Debug response from request , Default value false
    var debug       : Bool          = false
    
    /// completion : Response handler when request complete , Default value :  empty callback
    var completion  : RCResposeHandler<T>
    
    
    
    
    /// Init
    /// - Parameters:
    ///   - url: Remote Api Url
    ///   - method: Request Method , Default value : .get
    ///   - params: Request Parameters , Default value : nil
    ///   - headers: Request Header , Default value : nil
    ///   - file: File for upload, Default value : nil
    ///   - timeout: Request timeout , Default value 60s
    ///   - debug: Debug response from request , Default value false
    ///   - completion: Response handler when request complete , Default value :  empty callback
    public init(url: String,
                method: HTTPMethod = .get,
                params: Parameters? = nil,
                headers: HTTPHeaders? = nil,
                file: RCFile? = nil,
                timeout: TimeInterval = .init(60),
                debug: Bool = false,
                completion: @escaping RCResposeHandler<T>) {
        self.url = url
        self.method = method
        self.params = params
        self.headers = headers
        self.file = file
        self.timeout = timeout
        self.debug = debug
        self.completion = completion
    }

}


public struct RCURLRequestConfigure<T:Codable> {
       
    
    /// urlRequest : Use URLRequest  instead of url string
    var urlRequest  : URLRequest
    
    /// debug   : Debug response from request , Default value false
    var debug       : Bool = false
    
    /// completion : Response handler when request complete , Default value : empty callback
    var completion  :  RCResposeHandler<T>
    
    
    
    /// Init
    /// - Parameters:
    ///   - urlRequest: Use URLRequest  instead of url string
    ///   - debug: Debug response from request , Default value false
    ///   - completion: Response handler when request complete , Default value : empty callback
    public init(urlRequest: URLRequest,
                debug: Bool = false,
                completion: @escaping RCResposeHandler<T>) {
        self.urlRequest = urlRequest
        self.debug = debug
        self.completion = completion
    }

}


public struct RCResponseConfigure<T:Codable> {
  
   
    
    /// response : Request Response
    var response    : DataResponse<Data, AFError>
    
    /// method     : Request method for checking request response
    var method      : HTTPMethod = .get
    
    /// completion : Response handler when request complete , Default value :  empty callback
    var completion  : RCResposeHandler<T>
    
    
    /// debug
    var debug : Bool = false
    
    /// Init
    /// - Parameters:
    ///   - response: Request Response
    ///   - method: Request method for checking request response
    ///   - completion: Response handler when request complete , Default value :  empty callback
    public init(response: DataResponse<Data, AFError>,
                method: HTTPMethod = .get,
                debug : Bool = false,
                completion: @escaping RCResposeHandler<T>) {
        self.response = response
        self.method = method
        self.debug = debug
        self.completion = completion
    }
    
    
}
