//
//  ShowTransformerInteractor.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-16.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

protocol ShowTransformerLogic {
    func getTransformers()
}

class ShowTransformerInteractor : ShowTransformerLogic{
    
    var presenter:ShowTransformerPresenterLogic? = nil
    
    func getTransformers() {
        //        Current.service call?
        let transformerModels = Transformers.current.DB
        let presentTransformers = transformerModels
            .map {(id, transformer) in
                ShowTransformer.Present.List.Transformer(ID: transformer.id, name: transformer.name
                , teamName: transformer.team.rawValue)}
        
        presenter?.showTransformerList(ShowTransformer.Present.List(transformers: presentTransformers))
    }
}

