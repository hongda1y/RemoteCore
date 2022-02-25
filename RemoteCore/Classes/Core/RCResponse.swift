//
//  RemoteResponse.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation

/// RCDeleteResponse : default remotecore base response class
public class RCBaseResponse<T:Codable> : Codable {
    public var count : Int = 0
    public var next : String?
    public var previous : String?
    public var results : [T]?
    public var non_field_errors : [String]?
    public var message : String?
}


/// RCDeleteResponse : default remotecore delete response class
public class RCDeleteResponse : Codable {
    public var message : String?
}


/// RCErrorResponse : default remotecore error response class
public class RCErrorResponse : Codable {
    public var message : String?
}


/// RCUserResponse : default remotecore user response protocol
open class RCUserResponse : Codable {}



/// RCUser : default remotecore user protocol
public protocol RCUser : Codable {
    var id : String { get }
}
