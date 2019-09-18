//
//  ShowTransformersPresenter.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-16.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

protocol ShowTransformersPresenterLogic {
    func showTransformersList(_ list:ShowTransformer.Present.List)
}

class ShowTransformersPresenter : ShowTransformersPresenterLogic {
    var view:ShowTransformersDisplay? = nil
    func showTransformersList(_ list: ShowTransformer.Present.List) {
        let transformers = list.transformers.map { ShowTransformer.Display.Transformer(ID: $0.ID, name: $0.name, teamName: $0.teamName, imageURL: $0.imageURL, rating: String($0.rating))}
        view?.showTransformers(transformers)
    }
}
