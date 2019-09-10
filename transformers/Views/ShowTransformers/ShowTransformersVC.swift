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
    
    @IBOutlet weak var table: UITableView!
    var transformers:[ShowTransformer.Display.Transformer]? = nil
    func showTransformers(_ transformerList: [ShowTransformer.Display.Transformer]) {
        transformers = transformerList
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    override func viewDidLoad() {
        table.dataSource = self
        table.delegate = self
        interactor?.getTransformers()
    }
    
    var interactor:ShowTransformerLogic? = nil
    func setup() {
        let viewController = self
        let interactor = ShowTransformerInteractor()
        let presenter = ShowTransformerPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
}

extension ShowTransformersVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transformers?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        transformers?.count != nil ? 50 : 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let transformer = transformers?[indexPath.row],
            let cell = table.dequeueReusableCell(withIdentifier: "\(transformer.teamName)Cell")
            else {
            return table.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyCell
        }
//        cell.setup()
        return cell
    }
    
    
}

enum ShowTransformer {
    enum Display {
        struct Transformer {
            let name:String
            let teamName:String
        }
    }
    enum Present {
        struct TransformerList {
            struct PresentTransformerInfo{
                let name:String
                let teamName:String
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
                , teamName: $0.team.rawValue)}
        
        presenter?.showTransformerList(ShowTransformer.Present.TransformerList(transformers: presentTransformers))
    }
}

protocol ShowTransformerPresenterLogic {
    func showTransformerList(_ list:ShowTransformer.Present.TransformerList)
}

class ShowTransformerPresenter : ShowTransformerPresenterLogic {
    var view:ShowTransformersDisplay? = nil
    func showTransformerList(_ list: ShowTransformer.Present.TransformerList) {
        let transformers = list.transformers.map { ShowTransformer.Display.Transformer(name: $0.name, teamName: $0.teamName)}
        view?.showTransformers(transformers)
    }
}

class EmptyCell : UITableViewCell {
    
}
