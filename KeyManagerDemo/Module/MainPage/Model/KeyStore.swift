//
//  KeyStore.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/9.
//  Copyright © 2019 ma c. All rights reserved.
//

import Foundation
import WCDBSwift

class KeyStore: TableCodable{
    
    var id: Int = 0
    var title: String?
    var account : String?
    var password : String?
    var desc : String = "暂无描述"
    var backgroundColor : Int32?
    var height : Float = 100
    var time : Int?
    
    enum CodingKeys: String, CodingTableKey {
        
        typealias Root = KeyStore
        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case id
        case title
        case account
        case password
        case desc
        case backgroundColor
        case height
        case time
        
        static var columnConstraintBindings: [KeyStore.CodingKeys : ColumnConstraintBinding]? {
            
            return [
                id : ColumnConstraintBinding(isPrimary: true, orderBy: nil, isAutoIncrement: true, onConflict: nil, isNotNull: true, isUnique: true, defaultTo: .int32(11)),
                title : ColumnConstraintBinding.init(isPrimary: false, orderBy: nil, isAutoIncrement: false, onConflict: nil, isNotNull: false, isUnique: false, defaultTo: .text("暂无标题")),
                account : ColumnConstraintBinding.init(isPrimary: false, orderBy: nil, isAutoIncrement: false, onConflict: nil, isNotNull: false, isUnique: false, defaultTo: .text("暂无账户")),
                password : ColumnConstraintBinding.init(isPrimary: false, orderBy: nil, isAutoIncrement: false, onConflict: nil, isNotNull: false, isUnique: false, defaultTo: .text("暂无密码")),
                backgroundColor : ColumnConstraintBinding.init(isPrimary: false, orderBy: nil, isAutoIncrement: false, onConflict: nil, isNotNull: false, isUnique: false, defaultTo: .int32(0xFFFFFF)),
                desc : ColumnConstraintBinding.init(isPrimary: false, orderBy: nil, isAutoIncrement: false, onConflict: nil, isNotNull: false, isUnique: false, defaultTo: .text("暂无描述")),
                height : ColumnConstraintBinding.init(isPrimary: false, orderBy: nil, isAutoIncrement: false, onConflict: nil, isNotNull: false, isUnique: false, defaultTo: .float(100)),
                time : ColumnConstraintBinding.init(isPrimary: false, orderBy: nil, isAutoIncrement: false, onConflict: nil, isNotNull: false, isUnique: false, defaultTo: .int32(0))
            ]
        }
    }
    
    var isAutoIncrement: Bool {
        
        return true
    }
    
    var lastInsertedRowID: Int64 = 0
}
