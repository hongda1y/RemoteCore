//
//  RCLocal.swift
//  RemoteCore
//
//  Created by GBS Technology on 12/1/22.
//

import UIKit
import RealmSwift


public protocol RCLocalRepo {
    
    associatedtype T : Object
    
    /// Write object / objects
    func write(_ obj : T)
    func wiite(_ objs : [T])
    
    /// Update object
    func update(_ obj : T , update : () -> Void)
    
    /// Delete object/objects
    func delete(_ obj : T)
    func delete(_ id : Int)
    func delete(_ id : String)
    func deleteAll()
    
    /// Get all objects
    func getAll() -> [T]
    func getAll(sortKey : String, ascending : Bool) -> [T]
    func getAll(limit : Int,sortedKey : String) -> [T]
    func getAll(where query : String , limit : Int,sortedKey : String) -> [T]
    func getAll(query : String) -> [T]
    
    /// Get object/objects in raw form
    func getRawResults() -> Results<T>?
    
    /// Get object
    func get(id : Int) -> T?
    func get(id : String) -> T?
    func get(key : String , value : String) -> T?
    func get(query : String) -> T?
    
    /// Notify change when data change in T.Type table
    func notifyChange(change : @escaping (RealmCollectionChange<Results<T>>) -> Void)
    
    /// Total objects count in in T.Type table
    var objectCount : Int { get }
    
    /// Get last object of T.Type table
    func getLastObject(key : String) -> T?
    
    /// Get first object of T.Type table
    func getFirstObject(key : String) -> T?
    
}


open class RCLocal<T:Object> : RCLocalRepo{
  
    
    private let realm = RCDatabase.realm
    
    private var token: NotificationToken?
    
}


extension RCLocal {
    
    
    /// write
    /// - Parameter obj: Realm object
    public func write(_ obj: T) {
        try? realm?.write {
            realm?.add(obj,update: .modified)
        }
    }
    
    
    /// write
    /// - Parameter objs: Collection of realm objects
    public func wiite(_ objs: [T]) {
        try? realm?.write {
            realm?.add(objs,update: .modified)
        }
    }
    
    
    
    /// update
    /// - Parameters:
    ///   - obj: Realm object
    ///   - update: Callback for update object value before update (It's update in write cluster)
    public func update(_ obj: T, update: () -> Void) {
        try? realm?.write {
            update()
            realm?.add(obj, update: .modified)
        }
    }

    
    /// delete
    /// - Parameter obj: Realm object
    public func delete(_ obj: T) {
        try? realm?.write{
            realm?.delete(obj)
        }
    }
    
    
    /// delete
    /// - Parameter id: Object id (Int)
    public func delete(_ id: Int) {
        guard let obj = realm?.object(ofType: T.self, forPrimaryKey: id) else {
            return
        }
        delete(obj)
    }
    
    
    /// delete
    /// - Parameter id: Object id (String)
    public func delete(_ id: String) {
        guard let obj = realm?.object(ofType: T.self, forPrimaryKey: id) else {
            return
        }
        delete(obj)
    }
    
    
    
    /// deleteAll
    public func deleteAll() {
        
        guard let objs = realm?.objects(T.self) else {
            return
        }
        
        try? realm?.write{
            realm?.delete(objs)
        }
    }
    
    
    
    /// getAll
    /// - Returns: Array of realm object (T.Type)
    public func getAll() -> [T] {
        realm?.objects(T.self).toArray(type: T.self) ?? []
    }
    
    
    /// getAll
    /// - Parameters:
    ///   - sortKey: Sort key
    ///   - ascending: Ascending
    /// - Returns: Array of realm object (T.Type)
    public func getAll(sortKey: String, ascending: Bool) -> [T] {
        realm?.objects(T.self)
            .sorted(byKeyPath: sortKey,
                    ascending: ascending)
            .toArray(type: T.self) ?? []
    }
    
    
    
    /// getAll
    /// - Parameters:
    ///   - limit: limit object
    ///   - sortedKey: Sort key
    /// - Returns: Array of realm object (T.Type)
    public func getAll(limit: Int, sortedKey: String) -> [T] {
        var results = [T]()
        var count = limit
        if let objects = realm?.objects(T.self).sorted(byKeyPath: sortedKey, ascending: false) {
            
            if objects.count < count {
                count = objects.count
            }
            for i in 0..<count {
                results.append(objects[i])
            }
        }
        
        return results
    }
    
    
    /// getAll
    /// - Parameters:
    ///   - query: Realm query
    ///   - limit: Limit object
    ///   - sortedKey: Sort key
    /// - Returns: Array of realm object (T.Type)
    public func getAll(where query: String, limit: Int, sortedKey: String) -> [T] {
        
        var results = [T]()
        var count = limit
        if let objects = realm?
            .objects(T.self)
            .filter(query)
            .sorted(byKeyPath: sortedKey,
                    ascending: false) {
            
            if objects.count < count {
                count = objects.count
            }
            
            for i in 0..<count {
                results.append(objects[i])
            }
        }
        
        return results
    }
    
    
    /// getAll
    /// - Parameter query: Realm query
    /// - Returns: Array of realm object (T.Type)
    public func getAll(query: String) -> [T] {
        realm?.objects(T.self).filter(query).toArray(type: T.self) ?? []
    }
    
    
    
    /// getRawResults
    /// - Returns: Default result of realm objects
    public func getRawResults() -> Results<T>? {
        realm?.objects(T.self)
    }
    
    
    
    /// get
    /// - Parameter id: Object id (Int)
    /// - Returns: Realm Object (T.Type)
    public func get(id: Int) -> T? {
        realm?.object(ofType: T.self, forPrimaryKey: id)
    }
    
    
    /// get
    /// - Parameter id: Object id (String)
    /// - Returns: Realm Object (T.Type)
    public func get(id: String) -> T? {
        realm?.object(ofType: T.self, forPrimaryKey: id)
    }
    
    
    
    /// get
    /// - Parameters:
    ///   - key: object key
    ///   - value: object value
    /// - Returns: Realm Object (T.Type)
    public func get(key: String, value: String) -> T? {
        realm?.objects(T.self).filter("\(key) == '\(value)'").first
    }
    
    
    
    /// get
    /// - Parameter query: Realm query
    /// - Returns: Realm Object (T.Type)
    public func get(query: String) -> T? {
        realm?.objects(T.self).filter(query).first
    }
    
    
    
    /// notifyChange
    /// - Parameter change: Callback trigger when object of T.Type has data change
    public func notifyChange(change: @escaping (RealmCollectionChange<Results<T>>) -> Void) {
        token = realm?.objects(T.self).observe({ (observe) in
            change(observe)
        })
    }
    
    
    /// objectCount : Total Objects of providing object type
    public var objectCount: Int {
        return realm?.objects(T.self).count ?? 0
    }
    
    
    /// getLastObject
    /// - Parameter key: Sort key
    /// - Returns:Realm Object (T.Type)
    public func getLastObject(key : String) -> T? {
        realm?.objects(T.self).sorted(byKeyPath: key,ascending: false).first
    }
    
    /// getFirstObject
    /// - Parameter key: Sort key
    /// - Returns:Realm Object (T.Type)
    public func getFirstObject(key : String) -> T? {
        realm?.objects(T.self).sorted(byKeyPath: key,ascending: true).first
    }
}



extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
