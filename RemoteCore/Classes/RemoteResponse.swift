//
//  RemoteResponse.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation


public class RemoteResponse<T:DefaultRemoteModel> : Codable {
    var count : Int = 0
    var next : String?
    var previous : String?
    var results : [T]?
    var non_field_errors : [String]?
    var message : String?
}

public class DeleteResponse : Codable {
    var message : String?
}

public class ErrorResponse : Codable {
    var message : String?
}
