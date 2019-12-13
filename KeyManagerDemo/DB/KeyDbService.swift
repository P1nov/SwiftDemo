//
//  KeyDbService.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/10.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit
import WCDBSwift

let KeyStoreTableName = "KeyStore"

typealias KeyStoreOperateCompletion = (_ success : Bool, _ error : Error?) -> ()

typealias KeyStoreOperateSelectCompletion = (_ success : Bool, _ error : Error?, _ keyStores : [KeyStore]?) -> ()

class KeyDbService: NSObject {

    var dataBase : Database = Database.init(withFileURL: URL(fileURLWithPath: baseDirectory))
    
    private var update : Update!
    private var insert : Insert!
    private var delete : Delete!
    private var select : Select!
    
    static let shared : KeyDbService = {
        
        print(baseDirectory)
        
        let shared = KeyDbService()
        
        return shared
    }()
    
    func setUp() {
        
        do {
            
            update = try dataBase.prepareUpdate(table: KeyStoreTableName, on: [KeyStore.Properties.title, KeyStore.Properties.account, KeyStore.Properties.password, KeyStore.Properties.desc, KeyStore.Properties.backgroundColor, KeyStore.Properties.height, KeyStore.Properties.time])
            
            insert = try dataBase.prepareInsert(on: [KeyStore.Properties.id, KeyStore.Properties.title, KeyStore.Properties.account, KeyStore.Properties.password, KeyStore.Properties.desc, KeyStore.Properties.backgroundColor, KeyStore.Properties.height, KeyStore.Properties.time], intoTable: KeyStoreTableName)
            
            delete = try dataBase.prepareDelete(fromTable: KeyStoreTableName)
            
            select = try dataBase.prepareSelect(on: [KeyStore.Properties.id, KeyStore.Properties.title, KeyStore.Properties.account, KeyStore.Properties.password, KeyStore.Properties.desc, KeyStore.Properties.backgroundColor, KeyStore.Properties.height, KeyStore.Properties.time], fromTable: KeyStoreTableName)
            
        }catch let exError {
            
            print(exError)
        }
    }
    
    
    /*
     
     创建钥匙串本地数据表
     */
    func createKeyStoreTable() {
        
        do {
            
            if dataBase.canOpen {
                
                try dataBase.create(table: KeyStoreTableName, of: KeyStore.self)
            }
        }catch let exError {
            
            print(exError)
        }
        
        
    }
    /*
     
     新增钥匙串
     */
    func addKeyStoreByKeyStore(keyStore : KeyStore, CompletionBlock : KeyStoreOperateCompletion) {
        
        do {
            
            let key : KeyStore = KeyStore()
            
            key.id = keyStore.id
            key.title = keyStore.title
            key.account = keyStore.account
            key.password = keyStore.password
            key.desc = keyStore.desc
            key.backgroundColor = keyStore.backgroundColor
            key.height = keyStore.height
            key.time = keyStore.time
            
//            try dataBase.insert(objects: key, intoTable: KeyStoreTableName)
            try insert.execute(with: key)
            
            CompletionBlock(true, nil)
            
        }catch let error {
            
            CompletionBlock(false, (error as! Error))
        }
    }
    
    /*
     
     编辑修改钥匙串
     */
    func editKeyStoreWithKeyStore(keyStore : KeyStore, CompletionBlock : KeyStoreOperateCompletion) {
        
        do {
            
            try update.where(keyStore.id == KeyStore.Properties.id).execute(with: keyStore)
            
            CompletionBlock(true, nil)
        }catch let error {
            
            CompletionBlock(false, (error as! Error))
        }
    }
    
    /*
     
     删除指定钥匙串
     */
    func deleteKeyStoreByKeyStore(keyStore : KeyStore, CompletionBlock : KeyStoreOperateCompletion) {
        
        do {
            
            try dataBase.delete(fromTable: KeyStoreTableName, where: KeyStore.Properties.id == keyStore.id, orderBy: nil, limit: nil, offset: nil)
            
            CompletionBlock(true, nil)
        }catch let error {
            
            CompletionBlock(false, (error as! Error))
        }
    }
    
    func selectKeyStoresFromTable(CompletionBlock : KeyStoreOperateSelectCompletion){
        
        do {
            
            let KeyStores = try select.allObjects(of: KeyStore.self)
            
            CompletionBlock(true, nil, KeyStores)
        }catch let error {
            
            print(error)
            return CompletionBlock(false, (error as! Error), nil)
        }
    }
    
}
