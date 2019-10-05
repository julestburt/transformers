//
//  CreateTransformerModel.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

enum CreateTransformerModel {
    enum Create {
        struct NewTransformer {
            let name:String
            let team:String
            let id:String?
            let properties:[String:Int]
        }
    }
    enum Created {
        struct CreatedTransformer {
            let name:String
            let rating:Int
            let team:String
            let imageName:String
        }
    }
}
