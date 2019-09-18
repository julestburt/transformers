//
//  Transformer.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit
import SwiftyJSON

let TransformerProperties =
    ["strength","intelligence","speed","endurance","rank","courage","firepower","skill"]

enum Team : String , Encodable, Decodable {
    case autobot = "A"
    case decepticon = "D"
}

struct Transformer: Encodable, Decodable {
    let id:String
    var name:String
    let strength:Int
    let intelligence:Int
    let speed:Int
    let endurance:Int
    let rank:Int
    let courage:Int
    let firepower:Int
    let skill:Int
    let team:Team
    let team_icon:String
    var overall_rating:Int {
        return self.strength + self.intelligence + self.speed + self.endurance + self.firepower
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
    
    init?(_ jsonString:String) {
        print(jsonString)
        guard let jsonData = jsonString.data(using: .utf8),
        let transformer = Transformer.init(jsonData) else { return nil }
        self = transformer
    }
        
    init?(_ jsonData:Data) {
        do {
            let jsonDecoder = JSONDecoder()
            let transformer = try jsonDecoder.decode(Transformer.self, from: jsonData)
            self = transformer
            print("Created \(transformer.name)")
        } catch {
            print("unable to create transformer from jsonData:\n")
            return nil
        }
    }
    
    static func makeTransformer(name:String, id:String? = nil, team:Team) -> Transformer {
        let id:String = id ?? UUID.init().uuidString
        let jsonTransformer = """
        {
        "id": "\(id)", "name": "\(name)", "strength": 10,
        "intelligence": 10,
        "speed": 4,
        "endurance": 8,
        "rank": 10,
        "courage": 9,
        "firepower": 10,
        "skill": 9,
        "team": "\(team.rawValue)",
        "team_icon":
        "https://tfwiki.net/mediawiki/images2/archive/8/8d/20110410191659%21Symbol_decept_reg.png"
        }
        """
        return Transformer(jsonTransformer)!
    }
}

