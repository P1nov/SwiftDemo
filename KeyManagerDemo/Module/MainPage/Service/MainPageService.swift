//
//  MainPageService.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class MainPageService: NSObject {

    var mainPageKeyStores : [KeyStore]?
    
    func getKeyStores(Completion : (_ success : Bool, _ error : Error?) -> ()){
        
        KeyDbService.shared.selectKeyStoresFromTable { (success, error, keyStores) in
            
            if success {
                
                mainPageKeyStores = keyStores
                
                mainPageKeyStores = mainPageKeyStores?.map({ (keyStore) -> KeyStore in
                    
                    if keyStore.desc.isEmpty || keyStore.desc.elementsEqual("暂无描述") {
                        
                        keyStore.height = 110.0
                    }else {
                        
                        keyStore.height = 250.0
                    }
                    
                    return keyStore
                })
                
                Completion(true, nil)
            }else {
                
                Completion(false, nil)
            }
        }
        
    }
    
    
}
