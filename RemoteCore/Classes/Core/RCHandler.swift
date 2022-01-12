//
//  RCHandler.swift
//  RemoteCore
//
//  Created by GBS Technology on 6/1/22.
//

import Foundation

public typealias RCUserResponseHandler = (Result<RCUserResponse?,RCError>) -> Void

public typealias RCResposeHandler<T:Codable> = (Result<T?,RCError>)->Void
