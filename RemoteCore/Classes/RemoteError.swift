//
//  RemoteError.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation
import Alamofire

public enum RemoteError :  Error {
    case decodeError(Any)
    case error(AFError)
    case csError(CSError)
    case badRequest(String)
}

extension RemoteError: LocalizedError {
    
    public var message : String {
        switch self {
        case .badRequest(let mgs) :
            return mgs
        case .csError(let err):
            return err.rawValue
        case .decodeError(let data):
            return data as? String ?? ""
        case .error(let afError):
            return afError.localizedDescription
        }
    }
    
}


public enum CSError : String , Error {
    
    case server_error = "server_error"
    
    case no_connection = "no_connection"
    
    case incorrent_passcode = "incorrect_passcode"
    
    case passcode_not_match = "passcode_not_match"
    
    case incorrect_pass_or_user = "incorrect_pass_or_username"
    
    case json_response_error = "response_error"
    
    case json_encode_err = "json_encode_err"
    
    case something_went_wrong = "something_went_wrong"
    
    case failed_to_create_passcode = "failed_to_create_passcode"
    
    case missing_field = "missing_field"
    
    case missing_file  = "missing_file"
    
    case missing_header  = "missing_header"
    
    case valid = "valid"
    
    case no_user = "no_user"
    
    case upload_failed = "upload_failed"
    
    case invalid_url = "invalid_url"
    
    
    case token_expired = "Token expired or access deny"
    
}
