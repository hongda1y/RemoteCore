//
//  BaseService.swift
//  RemoteCore_Example
//
//  Created by GBS Technology on 6/1/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import RemoteCore


class BaseService : RCDefaultService {}



class DemoClass{
    
    private let baseService = BaseService()
    
    func test() {
        fetchPost()
    }
    
    
    private func fetchPost() {
        
        baseService
            .fetchItems(of: PostResponse.self,
                        with:.init(url: "https://gorest.co.in/public/v1/posts",
                                          page: 1,
                                          limit: 20,
                                          debug: false,
                                          completion: { result in
            
            switch result {
            case .failure( _) :
                break
            case .success(let data):
                print(data?.data.count ?? 0)
                break
            }
        }))
    }
}

