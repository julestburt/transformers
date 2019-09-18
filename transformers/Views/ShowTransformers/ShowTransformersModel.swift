//
//  ShowTransformersModel.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-16.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

enum ShowTransformer {
    enum Display {
        struct Transformer {
            let ID:String
            let name:String
            let teamName:String
            let imageURL:String
            let rating:String
        }
    }
    enum Present {
        struct List {
            struct Transformer {
                let ID:String
                let name:String
                let teamName:String
                let imageURL:String
                let rating:Int
            }
            let transformers:[Transformer]
        }
    }
}
