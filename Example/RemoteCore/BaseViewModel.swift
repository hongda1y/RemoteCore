//
//  BaseViewModel.swift
//  RemoteCore_Example
//
//  Created by GBS Technology on 6/1/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import RemoteCore


class BaseViewModel<T:Codable>  {
    
    let baseService = BaseService()
    let test = RemoteClassDemo()
    
    var items : [T] = []
    
    var onLoading   : () ->Void = {}
    var onError     : (RCError)->Void = {_ in}
    var onComplete  : () -> Void = {}
    
    
    func fetchItems() {
        test.fetchItem()
//        self.onLoading()
//        baseService.fetchItems(of: PostResponse<T>.self, with:.init(url: "https://gorest.co.in/public/v1/posts",page: 2,limit: 25,completion: { result in
//
//            switch result {
//            case .success(let data):
//                self.items = data?.data ?? []
//                print(self.items.count)
//                self.onComplete()
//                break
//            case .failure(let err):
//                self.onError(err)
//                break
//            }
//        }))
    }
    
}
