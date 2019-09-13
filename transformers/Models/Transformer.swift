//
//  Transformer.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

class Transformers {
    static var shared:Transformers = Transformers()
    let transformers:[Transformer] = []
}

enum Team : String , Encodable{
    case autobot = "A"
    case decepticon = "D"
}

struct Transformer: Encodable {
    let id:String
    let name:String
    let strength:Int
    let intelligence:Int
    let speed:Int
    let endurance:Int
    let rank:Int
    let courage:Int
    let firepower:Int
    let skill:Int
    let team:Team
    var overall_rating:Int {
        return self.strength + self.intelligence + self.speed + self.endurance + self.firepower
    }
    var image:UIImage? {
        return UIImage(named: self.team.rawValue)
    }
    
    var createJSON:String? {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            return nil
        }
    }

}
