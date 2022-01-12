//
//  RCDatabase.swift
//  RemoteCore
//
//  Created by GBS Technology on 12/1/22.
//

import Foundation
import RealmSwift
import Security


public class RCDatabase: NSObject {
    
    private static var defaultConfig = Realm.Configuration(
        encryptionKey: RCEncryptionKey.getKey() as Data, //For Production
        schemaVersion: 1,
        migrationBlock: { migration, oldSchemaVersion in
    })
    
    public class func updateConfig(_ config : Realm.Configuration) {
        defaultConfig = config
    }
    
    public static let realm : Realm? = {
        Realm.Configuration.defaultConfiguration = defaultConfig
        print("RCDatabase : ",defaultConfig.fileURL?.path ?? "None")
        return try? Realm()
    }()
    
}


public class RCEncryptionKey : NSObject {
    
    public class func getKey() -> NSData {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "io.Realm.EncryptionExampleKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }
        
        // No pre-existing key from this application, so generate a new one
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")
        
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData
    }
    
}
