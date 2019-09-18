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
    
    func getTransformers() {
        //        Current.service call?
        let currentTransformers = Transformers.current.DB
        let presentTransformers = currentTransformers
            .map {(id, transformer) in
                ShowTransformer.Present.List.Transformer(ID: transformer.id, name: transformer.name
                , teamName: transformer.team.rawValue)}
        
        presenter?.showTransformersList(ShowTransformer.Present.List(transformers: presentTransformers))
        
        Transformers.current.subscribeToUpdates { (transformers) in
            let presentTransformers = transformers
                .map { transformer in
                    ShowTransformer.Present.List.Transformer(ID: transformer.id, name: transformer.name
                        , teamName: transformer.team.rawValue, imageURL: transformer.team_icon, rating: transformer.overall_rating)}
            self.presenter?.showTransformersList(ShowTransformer.Present.List(transformers: presentTransformers))
        }
    }
}


