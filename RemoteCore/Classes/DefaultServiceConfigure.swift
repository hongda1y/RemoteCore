//
//  DefaultServiceConfigure.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation

public typealias RCUserResponse = (Result<RCUser?,RemoteError>) -> Void


public struct DefaultServiceConfigure<T:Codable> {
    var url         : String
    var item        : T?        = nil
    var page        : Int       = 1
    var limit       : Int       = 20
    var query       : String?   = nil
    var pagination  : Bool      = false
    var debug       : Bool      = false
    var completion  : RCUserResponse = {_ in}
}
