//
//  TransformerDB.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-18.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

//------------------------------------------------------------------------------
// MARK: The resident current list of Transformers
//------------------------------------------------------------------------------
class Transformers {
    //    static var current = Transformers()
    static let current:Transformers = {
        let transformers = Transformers()
        transformers.restoreTransformers()
        transformers.refreshFromServer()
        return transformers
    }()
    
    private init() {
        self._transformers = [:]
        // restore any saved Transformers
    }
    
    var sendToDelegate:(([Transformer])->Void)? = nil
    func subscribeToUpdates(_ reportTo:@escaping([Transformer])->Void) {
        sendToDelegate = reportTo
    }
    
    func refreshFromServer() {
        Current.apiService?.getTransformers()
            .then { tranformerList in
                self.setTransformerDB(tranformerList)
                self.sendToDelegate?(self.DB.map { $1 })
        }.onError { error in
            if let error = error as? CustomError {
                print(print("refreshTransformers failed:\(error.title ?? "no-title")"))
            }
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
    
    func addCreatedTransformer(_ transformer:Transformer) {
        safeSerialQueueTransformer.async(flags:.barrier) {
            self._transformers[transformer.id] = transformer
            self.storeToUserDefaults(self._transformers)
        }
        self.sendToDelegate?(self.DB.map { $1 })
    }

    func setTransformerDB(_ toStore:[Transformer]) {
        safeSerialQueueTransformer.async(flags:.barrier) {
            self._transformers = [:]
            for transformer in toStore {
                self._transformers[transformer.id] = transformer
            }
            self.storeToUserDefaults(self._transformers)
        }
        self.sendToDelegate?(self.DB.map { $1 })
    }
    
    func removeTransformer(_ idToRemove:String) {
        guard let transformer = self.transformerForID(idToRemove) else { return }
        safeSerialQueueTransformer.async(flags:.barrier) {
            self._transformers.removeValue(forKey: transformer.id)
            self.storeToUserDefaults(self._transformers)
        }
        self.sendToDelegate?(self.DB.map { $1 })
    }

    private func restoreTransformers() {
        guard let transformers = self.restoreFromUserDefaults() else { return }
        setTransformerDB(transformers)
    }
    
    //------------------------------------------------------------------------------
    // MARK: Store / Restore localDB to UserDefaults
    //------------------------------------------------------------------------------
    fileprivate func storeToUserDefaults(_ transformers:[String:Transformer]) {
        let jsonString = "[\(transformers.compactMap { $0.value.createJSON }.joined(separator: ","))]"
        UserDefaults.standard.set(jsonString, forKey: UserDefaults.keys.transformerStore)
    }
    
    fileprivate func restoreFromUserDefaults() -> [Transformer]? {
        guard let storedTransformerJSON = UserDefaults.standard.object(forKey: UserDefaults.keys.transformerStore) as? String,
            let jsonStringData = storedTransformerJSON.data(using: .utf8),
            let transformers = try? JSONDecoder().decode([Transformer].self, from: jsonStringData)
           else { return nil }
        return transformers
    }
}
