//
//  ShowTransformersInteractor.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-16.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

protocol ShowTransformersLogic {
    func getTransformers()
}

class ShowTransformersInteractor : ShowTransformersLogic {
    
    var presenter:ShowTransformersPresenterLogic? = nil
    
    fileprivate func createPresenterList(_ transformers: [Transformer]) -> [ShowTransformer.Present.List.Transformer] {
        return transformers
            .sorted { $0.overall_rating > $1.overall_rating }
            .sorted { $0.name > $1.name }
            .map { transformer in
                ShowTransformer.Present.List.Transformer(ID: transformer.id, name: transformer.name
                    , teamName: transformer.team.rawValue, imageURL: transformer.team_icon, rating: transformer.overall_rating)}
    }
    
    func getTransformers() {
        let transformers = Transformers.current.DB.map { $1 }
        presenter?.showTransformersList(ShowTransformer.Present.List(transformers: self.createPresenterList(transformers)))
        
        Transformers.current.subscribeToUpdates { (transformers) in
            self.presenter?.showTransformersList(ShowTransformer.Present.List(transformers: self.createPresenterList(transformers)))
        }
    }
}


