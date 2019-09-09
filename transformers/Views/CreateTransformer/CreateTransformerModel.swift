//
//  CreateTransformerModel.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

let TransformerProperties =
    ["strength","intelligence","speed","endurance","rank","courage","firepower","skill"]

enum TransformerProperty : String {
    case strength
    case intelligence
    case speed
    case endurance
    case rank
    case courage
    case firepower
    case skill
}

enum CreateTransformerModel {
    enum Create {
        /*
         {
         "id": 0,
         "name": "string",
         "team": "string",
         "strength": 0,
         "intelligence": 0,
         "speed": 0,
         "endurance": 0,
         "rank": 0,
         "courage": 0,
         "firepower": 0,
         "skill": 0
         }
         */
        struct NewTransformer {
            var name:String
            var team:String
            var strength:Int
            var intelligence:Int
            var speed:Int
            var endurance:Int
            var rank:Int
            var courage:Int
            var firepower:Int
            var skill:Int
        }
    }
}