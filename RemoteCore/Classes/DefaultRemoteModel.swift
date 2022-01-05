//
//  BaseRemoteModel.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation

public protocol DefaultRemoteModel : Codable {
    var baseTitle   : String { get }
    var baseId      : String { get }
}
