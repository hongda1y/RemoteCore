//
//  RCUserService.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation
import Alamofire


public struct RCAuthURL {
    
    
    public init(login: String? = nil,
                register: String? = nil,
                verifyOTP: String? = nil,
                resendOTP: String? = nil,
                updateProfile: String? = nil,
                uploadProfileImage: String? = nil,
                createRemotePasscode: String? = nil,
                updateRemotePasscode: String? = nil,
                forgetPasscode: String? = nil) {
        
        self.login = login
        self.register = register
        self.verifyOTP = verifyOTP
        self.resendOTP = resendOTP
        self.updateProfile = updateProfile
        self.uploadProfileImage = uploadProfileImage
        self.createRemotePasscode = createRemotePasscode
        self.updateRemotePasscode = updateRemotePasscode
        self.forgetPasscode = forgetPasscode
    }
    
    
    /// login URL
    var login                   : String?
    
    /// register URL
    var register                : String?
    
    /// verifyOTP URL
    var verifyOTP               : String?
    
    /// resendOTP URL
    var resendOTP               : String?
    
    /// updateProfile URL
    var updateProfile           : String?
    
    /// uploadProfileImage URL
    var uploadProfileImage      : String?
    
    /// createRemotePasscode URL
    var createRemotePasscode    : String?
    
    /// updateRemotePasscode URL
    var updateRemotePasscode    : String?
    
    /// forgetPasscode URL
    var forgetPasscode          : String?
    
}


private protocol RCUserServiceRepo {
    
    /// Login
    /// - Parameters:
    ///   - number: Phone number
    ///   - completion: Callback handler when login complete
    func login(with number : String,
               completion : @escaping RCUserResponseHandler)
    
    
    
    /// Login
    /// - Parameters:
    ///   - email: Email
    ///   - password: Password for login
    ///   - completion: Callback handler when login complete
    func login(with email : String,
               password : String,
               completion : @escaping RCUserResponseHandler)
   
    
    
    
    /// Register
    /// - Parameters:
    ///   - user: user object that implement by developer
    ///   - completion: Callback handler when register complete
    func register<T:RCUser>(with user: T,
                  completion : @escaping RCUserResponseHandler)
    
    
    
    /// Verify OTP Code
    /// - Parameters:
    ///   - code: Code that received by sms
    ///   - phone: Phone number
    ///   - completion: Callback handler when verifyOTPCode complete
    func verifyOTPCode(code : String,
                       with phone : String,
                       completion : @escaping RCUserResponseHandler)
    
    
    /// Resend OTP Code
    /// - Parameters:
    ///   - phone: Phone number required to re-send verify code
    ///   - completion: Callback handler when resendOTPCode complete
    func resendOTPCode(phone : String,
                       completion : @escaping RCUserResponseHandler)
    
    
    
    /// Update Profile
    /// - Parameters:
    ///   - user: user object that implement by developer
    ///   - completion: Callback handler when updateProfile complete
    func updateProfile<T:RCUser>(_ user:T,
                       completion: @escaping RCUserResponseHandler)
    
    
    
    /// Upload Profile Image
    /// - Parameters:
    ///   - key: Key for upload
    ///   - imageData:
    ///   - completion: Callback handler when updateProfile complete
    func uploadProfileImage(_ key : String ,
                            imageData : Data,
                            completion: @escaping RCUserResponseHandler)
    
    
    /// Forget Password
    /// - Parameters:
    ///   - phone: Phone number
    ///   - completion: Callback handler when forgetPassword complete
    func forgetPassword(_ phone : String,
                        completion: @escaping RCUserResponseHandler)

    
    /// Create Local Passcode
    /// - Parameter code: Passcode
    func createLocalPasscode(code : String)
    
    
    /// Update Local Passcode
    /// - Parameter code: Update passcode
    func updateLocalPasscode(code : String)
    
    
    
    /// Disable Passcode
    func disablePasscode()
    
    
    /// Create Remote Passcode
    /// - Parameters:
    ///   - code: Passcode
    ///   - completion: Callback handler when createRemotePasscode complete
    func createRemotePasscode(code : String,
                              completion: @escaping RCUserResponseHandler)
    
    
    /// Update Remote Passcode
    /// - Parameters:
    ///   - code: Passcode
    ///   - completion: Callback handler when updateRemotePasscode complete
    func updateRemotePasscode(code : String,
                              completion: @escaping RCUserResponseHandler)
    
}


open class RCUserService {
    
    /// headers : Default  headers that use user auth token
    open var headers : HTTPHeaders {
        .init()
    }
    
    /// baseHeaders : Default base headers use for login/register (base token)
    open var baseHeaders : HTTPHeaders {
        .init()
    }
    
    /// authUrl : All auth url required use in userservice
    open var authUrl : RCAuthURL {
        .init()
    }
    
    
    
    /// enableDebug : Enable request debug for user service
    open var enableDebug : Bool {
        false
    }
    
    /// rcRemote : Remote Object
    public let rcRemote = RCRemote()
    
    
}



extension RCUserService : RCUserServiceRepo {
    
    /// Login
    /// - Parameters:
    ///   - number: Phone number
    ///   - completion: Callback handler when login complete
    public func login(with number: String,
                      completion: @escaping RCUserResponseHandler) {
       
        guard let url = authUrl.login else {
            completion(.failure(.customError(.missing_url)))
            return
        }
        
        let params = [
            "phone" : number,
            "login_type" : "mobile",
        ] as Parameters
        
        let configuration :
        RCConfigure<RCUserResponse> = .init(url: url,
                                            method: .post,
                                            params: params,
                                            headers: baseHeaders,
                                            debug: enableDebug) {
            completion($0)
        }
        
        rcRemote.request(configuration: configuration)
    }
    
    
    /// Login
    /// - Parameters:
    ///   - email: Email
    ///   - password: Password for login
    ///   - completion: Callback handler when login complete
    public func login(with email: String,
                      password: String,
                      completion: @escaping RCUserResponseHandler) {
        
        guard let url = authUrl.login else {
            completion(.failure(.customError(.missing_url)))
            return
        }
        
        let params = [
            "email" : email,
            "password" : password,
            "login_type" : "mobile",
        ] as Parameters
        
        let configuration :
        RCConfigure<RCUserResponse> = .init(url: url,
                                            method: .post,
                                            params: params,
                                            headers: baseHeaders,
                                            debug: enableDebug) {
            completion($0)
        }
        
        rcRemote.request(configuration: configuration)
    }
    
    
    /// Register
    /// - Parameters:
    ///   - user: user object that implement by developer
    ///   - completion: Callback handler when register complete
    public func register<T:RCUser>(with user : T,
                                   completion: @escaping RCUserResponseHandler) {
        
        guard let url = authUrl.register else {
            completion(.failure(.customError(.missing_url)))
            return
        }
       
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(user)
        guard let jData = jsonData else {
            completion(.failure(.customError(.json_response_error)))
            return
        }

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.headers = headers
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.httpBody = jData
        
        let configure :
        RCURLRequestConfigure<RCUserResponse> = .init(urlRequest: urlRequest,
                                                      debug: enableDebug) {
            completion($0)
        }
        
        rcRemote.request(configuration: configure)
        
        
    }
    
    
    /// Verify OTP Code
    /// - Parameters:
    ///   - code: Code that received by sms
    ///   - phone: Phone number
    ///   - completion: Callback handler when verifyOTPCode complete
    public func verifyOTPCode(code: String,
                              with phone: String,
                              completion: @escaping RCUserResponseHandler) {
        
        guard let url = authUrl.verifyOTP else {
            completion(.failure(.customError(.missing_url)))
            return
        }
        
        let params = [
            "phone" : "\(phone)",
            "code" : code
        ]
        
        let configuration :
        RCConfigure<RCUserResponse> = .init(url: url,
                                            method: .post,
                                            params: params,
                                            headers: baseHeaders,
                                            debug: enableDebug) {
            completion($0)
        }
        
        rcRemote.request(configuration: configuration)
        
    }
    
    
    
    /// Resend OTP Code
    /// - Parameters:
    ///   - phone: Phone number required to re-send verify code
    ///   - completion: Callback handler when resendOTPCode complete
    public func resendOTPCode(phone: String,
                              completion: @escaping RCUserResponseHandler) {
        
        guard let url = authUrl.resendOTP else {
            completion(.failure(.customError(.missing_url)))
            return
        }
        
        let params = [
            "phone" : "\(phone)"
        ]
        
        let configuration :
        RCConfigure<RCUserResponse> = .init(url: url,
                                            method: .post,
                                            params: params,
                                            headers: baseHeaders,
                                            debug: enableDebug) {
            completion($0)
        }
        
        rcRemote.request(configuration: configuration)
        
    }
    
    
    /// Forget Password
    /// - Parameters:
    ///   - phone: Phone number
    ///   - completion: Callback handler when forgetPassword complete
    func forgetPassword(_ phone: String,
                        completion: @escaping RCUserResponseHandler) {
        
    }
    
    
    
    /// Upload Profile Image
    /// - Parameters:
    ///   - key: Key for upload
    ///   - imageData: Image data
    ///   - completion: Callback handler when uploadProfileImage complete
    func uploadProfileImage(_ key: String,
                            imageData: Data,
                            completion: @escaping RCUserResponseHandler) {
        
        guard let url = authUrl.uploadProfileImage else {
            completion(.failure(.customError(.missing_url)))
            return
        }
        
        let configure : RCConfigure<RCUserResponse> = .init(url: url,
                                                   method: .get,
                                                   headers: headers,
                                                   file: .init(data:imageData,fileUploadKey: key),
                                                   debug: enableDebug) {
            
            completion($0)
        
        }
        
        rcRemote.uploadFile(configuration: configure)
        
        
    
        
    }
    
    /// Update Profile
    /// - Parameters:
    ///   - user: user object that implement by developer
    ///   - completion: Callback handler when updateProfile complete
    public func updateProfile<T:RCUser>(_ user: T,
                              completion: @escaping RCUserResponseHandler) {
        
        guard let url = authUrl.updateProfile else {
            completion(.failure(.customError(.missing_url)))
            return
        }
        
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(user)
        
        guard let jData = jsonData else {
            completion(.failure(.customError(.json_response_error)))
            return
        }

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.headers = headers
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.httpBody = jData
        
        let configure :
        RCURLRequestConfigure<RCUserResponse> = .init(urlRequest: urlRequest,
                                                      debug: enableDebug) {
            completion($0)
        }
        
        rcRemote.request(configuration: configure)
        
    }
    
    
    
    /// Create Local Passcode
    /// - Parameter code: Passcode
    public func createLocalPasscode(code: String) {}
    
    
    /// Update Local Passcode
    /// - Parameter code: Update passcode
    public func updateLocalPasscode(code: String) {}
    
    
    
    /// Disable Passcode
    public func disablePasscode() {}
    
    
    /// Create Remote Passcode
    /// - Parameters:
    ///   - code: Passcode
    ///   - completion: Callback handler when createRemotePasscode complete
    public func createRemotePasscode(code: String,
                                     completion: @escaping RCUserResponseHandler) {}
    
    
    /// Update Remote Passcode
    /// - Parameters:
    ///   - code: Passcode
    ///   - completion: Callback handler when updateRemotePasscode complete
    public func updateRemotePasscode(code: String,
                                     completion: @escaping RCUserResponseHandler) {}
    
    
}
