//
//  TransformerDB.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-18.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

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

