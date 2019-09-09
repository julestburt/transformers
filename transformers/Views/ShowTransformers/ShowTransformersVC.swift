//
//  ShowTransformersVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

protocol ShowTransformersDisplay {
    func showTransformers(_ transformerList:[ShowTransformer.Display.Transformer])
}

class ShowTransformersVC : UIViewController, ShowTransformersDisplay {
    
    var tranformers:[ShowTransformer.Display.Transformer]? = nil
    func showTransformers(_ transformerList: [ShowTransformer.Display.Transformer]) {
        tranformers = transformerList
    }
    
    override func viewDidLoad() {
        // request list of transformers
    }
}

enum ShowTransformer {
    enum Display {
        struct Transformer {
            let name:String
            let imageURL:String
        }
    }
    enum Present {
        struct TransformerList {
            struct PresentTransformerInfo{
                let name:String
                let image:String
            }
            let transformers:[PresentTransformerInfo]
        }
    }
}

protocol ShowTransformerLogic {
    func getTransformers()
}

class ShowTransformerInteractor : ShowTransformerLogic{
    
    var presenter:ShowTransformerPresenterLogic? = nil
    
    func getTransformers() {
//        Current.service
        let transformerModels = Transformers.shared.transformers
        let presentTransformers = transformerModels
            .map { ShowTransformer.Present.TransformerList.PresentTransformerInfo(name: $0.name
                , image: $0.team.rawValue)}
        
        presenter?.showTransformerList(ShowTransformer.Present.TransformerList(transformers: presentTransformers))
    }
}

protocol ShowTransformerPresenterLogic {
    func showTransformerList(_ list:ShowTransformer.Present.TransformerList)
}

class Transformers {
    static var shared:Transformers = Transformers()
    let transformers:[Transformer] = []
}

enum Team : String {
    case autobot
    case decepticon
}

struct Transformer {
    let id:String
    let name:String
    let strength:Int
    let intelligence:Int
    let speed:Int
    let endurance:Int
    let rank:Int
    let courage:Int
    let firepower:Int
    let skill:Int
    let team:Team
    var overall_rating:Int {
        return self.strength + self.intelligence + self.speed + self.endurance + self.firepower
    }
    var image:UIImage? {
        return UIImage(named: self.team.rawValue)
    }
}


