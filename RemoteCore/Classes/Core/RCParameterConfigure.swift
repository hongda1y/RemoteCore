//
//  RCServiceConfigure.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation


public class RCParameterConfigure<T:Codable> {
    
    var url         : String
    var item        : T?        = nil
    var itemId      : String?   = nil
    var page        : Int       = 1
    var limit       : Int       = 20
    var query       : String?   = nil
    var pagination  : Bool      = false
    var debug       : Bool      = false
    var completion  : RCResposeHandler<T> = {_ in}
    var file        : RCFile?   = nil


    public init(url: String,
                page: Int = 1,
                limit: Int = 20,
                debug: Bool = false,
                completion: @escaping RCResposeHandler<T> = {_ in}) {
        self.url = url
        self.page = page
        self.limit = limit
        self.debug = debug
        self.completion = completion
    }



    public init(url: String,
                item: T? = nil,
                debug: Bool = false,
                completion: @escaping RCResposeHandler<T> = {_ in}) {
        self.url = url
        self.item = item
        self.debug = debug
        self.completion = completion
    }


    public init(url: String,
                query: String? = nil,
                pagination: Bool = false,
                debug: Bool = false,
                completion: @escaping RCResposeHandler<T> = {_ in}) {
        self.url = url
        self.query = query
        self.pagination = pagination
        self.debug = debug
        self.completion = completion
    }

    
    public init(url: String,
                id : String,
                debug: Bool = false,
                completion: @escaping RCResposeHandler<T> = {_ in}) {
        self.url = url
        self.itemId = id
        self.debug = debug
        self.completion = completion
    }
    
    public init(url: String,
                file : RCFile,
                debug: Bool = false,
                completion: @escaping RCResposeHandler<T> = {_ in}) {
        self.url = url
        self.file = file
        self.debug = debug
        self.completion = completion
    }
}
