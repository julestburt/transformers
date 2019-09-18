//
//  CreateTransformerPresenter.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-15.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

//------------------------------------------------------------------------------
// MARK: Create Transformer Presenter Logic
//------------------------------------------------------------------------------

protocol CreateTransformerPresenterLogic {
    func confirmTransformerCreated(_ transformer:CreateTransformerModel.Created.CreatedTransformer)
}

class CreateTransformerPresenter : CreateTransformerPresenterLogic {
    var view:CreateTransformerDisplay? = nil
    
    func confirmTransformerCreated(_ transformer:CreateTransformerModel.Created.CreatedTransformer) {
        view?.showConfirmationCreated(transformer)
    }
}

