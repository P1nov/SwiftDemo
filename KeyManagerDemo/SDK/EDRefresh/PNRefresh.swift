//
//  PNRefresh.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/16.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class PNRefresh: PNRefreshComponent {

    class func checkState(oldState : PNRefreshState?, newState : PNRefreshState?) -> Bool {
        
        if oldState == newState {
            
            return false
        }
        
        return true
    }
}
