//
//  PostResponse.swift
//  RemoteCore_Example
//
//  Created by GBS Technology on 6/1/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

struct PostResponse<T:Codable> : Codable {
    var data : [T]
}
