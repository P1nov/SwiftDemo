//
//  EditService.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit
import WCDBSwift

class EditService: NSObject {

    var keyStore : KeyStore?

    func editKeyStoreByAdding(keyStore : KeyStore, CompletionBlock : ((_ success : Bool, _ error : Error?) -> ())) {
        
        var KeyStores : [KeyStore]
        
        if UserDefaults.standard.array(forKey: "keyStores") != nil {
            
            KeyStores = Array(UserDefaults.standard.array(forKey: "keyStores") as! [KeyStore])
        }else {
            
            KeyStores = [KeyStore].init()
        }
        
        KeyStores.append(keyStore)
        
        if KeyStores.count > 1 {
            
            KeyStores.sort(by: { (keyStore1 : KeyStore, keyStore2 : KeyStore) -> Bool in
                
                return keyStore1.time! > keyStore2.time!
            })
        }
        
        KeyDbService.shared.addKeyStoreByKeyStore(keyStore: keyStore) { (success, error) in
            
            if success {
                
                CompletionBlock(true, nil)
            }else {
                
                print(error!)
            }
        }
        
    }
    
    func editKeyStoreByUpdating(keyStore : KeyStore, CompletionBlock : KeyStoreOperateCompletion) {
        
        KeyDbService.shared.editKeyStoreWithKeyStore(keyStore: keyStore) { (success, error) in
            
            if success {
                
                CompletionBlock(true, nil)
            }else {
                
                CompletionBlock(false, error)
            }
        }
    }
    
    override init() {
        super.init()
        
        keyStore = KeyStore()
    }
}
