//
//  CreateTranformerInteractor.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-15.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

//------------------------------------------------------------------------------
// MARK: CreateTransformer Logic
//------------------------------------------------------------------------------
protocol CreateTransformerInteractorLogic {
    func createTransformer(_ request:CreateTransformerModel.Create.NewTransformer)
}

//------------------------------------------------------------------------------
// MARK: CreateTransformer Interactor
//------------------------------------------------------------------------------
class CreateTransformerInteractor : CreateTransformerInteractorLogic {
    var presenter:CreateTransformerPresenterLogic? = nil
    
    fileprivate func createChangeConfirm(_ transformer:Transformer) -> () {
        Transformers.current.addCreatedTransformer(transformer)
        let teamName = transformer.team == .autobot ? "autobot" : "decepticon"
        let simpleTransformerModel = CreateTransformerModel.Created.CreatedTransformer(name: transformer.name, rating:transformer.rank, team: teamName, imageName: transformer.team_icon)
        self.presenter?.confirmTransformerCreated(simpleTransformerModel)
    }
    
    func createTransformer(_ request: CreateTransformerModel.Create.NewTransformer) {
        
        guard let id = request.id else {
            Current.apiService?.createTransformer(request.name, team: request.team, properties: request.properties)
                .then(createChangeConfirm)
                .onError { error in
                    print(error.localizedDescription)
                    self.presenter?.failedToCreate()
            }
            return
        }
        
        Current.apiService?.changeTransformer(id, name: request.name, team: request.team, properties: request.properties)
            .then(createChangeConfirm)
            .onError { error in
                print(error.localizedDescription)
                self.presenter?.failedToCreate()
        }
    }
}
