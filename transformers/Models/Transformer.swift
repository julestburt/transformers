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

class Transformers {
//    static var current = Transformers()
    static let current:Transformers = {
        let transformers = Transformers()
        transformers.restoreTransformers()
        transformers.refreshFromServer()
        return transformers
    }()

    
    let notificationTransformerRefresh = "notificationTransformerRefresh"
    
    private init() {
        self._transformers = [:]
        // restore any saved Transformers
    }
    
    var delegate:(([Transformer])->Void)? = nil
    func subscribeToUpdates(_ reportTo:@escaping([Transformer])->Void) {
        delegate = reportTo
    }
    
    func refreshFromServer() {
        Current.apiService?.getTransformers()
            .then { tranformerList in
                self.storeTransformers(tranformerList)
                let array = self.DB.map { $1 }
                self.delegate?(array)
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: Lock changes to allow asyc updates...from creating, refresh etc..
    //------------------------------------------------------------------------------
    let safeSerialQueueTransformer = DispatchQueue(label: "safeSerialQueueTransformer", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)

    private var _transformers:[String:Transformer]
    var DB:[String:Transformer] {
        get {
            var local:[String:Transformer] = [:]
            safeSerialQueueTransformer.sync { for (id ,transformer) in
                _transformers { local[id] = transformer } }
            return local
        }
    }
    
    func transformerForID(_ ID:String) -> Transformer? {
        return DB.filter { $0.key == ID }.first?.value
    }
    
    

    
    func storeTransformers(_ toStore:[Transformer]) {
        safeSerialQueueTransformer.async(flags:.barrier) {
            self._transformers = [:]
            for transformer in toStore {
                self._transformers[transformer.id] = transformer
            }
            self.storeTransformers()
        }
    }
    
    func addCreatedTransformer(_ transformer:Transformer) {
        safeSerialQueueTransformer.async(flags:.barrier) {
            self._transformers[transformer.id] = transformer
            self.storeTransformers()
        }
    }
    
    //------------------------------------------------------------------------------
    // MARK: Store / Restore localDB to UserDefaults
    //------------------------------------------------------------------------------
    
    func restoreTransformers() {
        guard let storedTransformerJSON = UserDefaults.standard.object(forKey: UserDefaults.keys.transformerStore) as? String,
            let jsonData = storedTransformerJSON.data(using: .utf8),
            let json = try? JSON(data: jsonData),
            let jsonArrayTransformers = json["transformers"].array else { return }
        let transformers = jsonArrayTransformers.compactMap {
            Transformer($0.description)
        }
        storeTransformers(transformers)
    }
    
    
    func storeTransformers() {
        let jsonArrayTransformers = self._transformers.map { $0.value.createJSON }.compactMap { $0 }
        let result:JSON =  ["transformers":"[\(jsonArrayTransformers.joined(separator: ","))]"]
        UserDefaults.standard.set(result.description, forKey: UserDefaults.keys.transformerStore)
    }

}

// I wouldn't normally extend String just to accomodate this, I would create a new Transformer Name type and extend that!
extension String {
    func containsAny(_ names:[String]) -> Bool {
        return  names.reduce(false) {
              return $0 || $1 == self
        }
    }
}

