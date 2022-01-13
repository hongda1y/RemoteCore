//
//  BaseService.swift
//  RemoteCore_Example
//
//  Created by GBS Technology on 6/1/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import RemoteCore
import Alamofire

class BaseService : RCDefaultService {
    
    override var headers: HTTPHeaders {
        .init()
    }
}



class DemoClass{
    
    private let baseService = BaseService()
    
    func test() {
        fetchPost()
    }
    
    
    private func fetchPost() {
        
        let paramConfig : RCParameterConfigure<PostResponse<Post>> =
            .init(url: "https://gorest.co.in/public/v1/posts",
                  page: 1,
                  limit: 20,
                  debug: false) { result in
            switch result {
            case .success(let data):
                print(#function,data?.data.count ?? 0)
                break
            case .failure(let err):
                print(#function,err.message)
                break
            }
        }
        
        baseService.fetchItems(with: paramConfig)
        
    }
}


class RemoteClassDemo {
    
    private let rcRemote = RCRemote()
    
    
    func fetchItem() {
        
        let config = RCConfigure<PostResponse<Post>>.init(url: "https://gorest.co.in/public/v1/posts",headers: .default,debug: true) { result in
            switch result {
            case .success(let data):
                print(data?.data ?? [])
                break
            case .failure(let err):
                print(err.message)
                break
            }
        }
        
        rcRemote.request(configuration: config)
        
    }
}



class Test
{
    
}
