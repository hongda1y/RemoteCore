//
//  DefaultUserService.swift
//  RemoteCore
//
//  Created by GBS Technology on 5/1/22.
//

import Foundation


public protocol RCUser : Codable {}

private protocol DefaultUserServiceRepo {
    
    func login(with number : String,completion : @escaping RCUserResponse)
    func login(with user : String , password : String,completion : @escaping RCUserResponse)
   
    func register(with : RCUser,completion : @escaping RCUserResponse)
    func verifyOTPCode(code : String,with phone : String,completion : @escaping RCUserResponse)
    func resendOTPCode(phone : String,completion : @escaping RCUserResponse)
    
    func updateProfile(_ user:RCUser,profile : Data , completion: @escaping RCUserResponse)

    
    func createLocalPasscode(code : String)
    func updateLocalPasscode(code : String)
    func disablePasscode()
    func createRemotePasscode(code : String, completion: @escaping RCUserResponse)
    func updateRemotePasscode(code : String, completion: @escaping RCUserResponse)
    
}
