//
//  ShowTransformersVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

//------------------------------------------------------------------------------
// MARK: View Display
//------------------------------------------------------------------------------

protocol ShowTransformersDisplay {
    func showTransformers(_ transformerList:[ShowTransformer.Display.Transformer])
}

extension ShowTransformersVC : ShowTransformersDisplay {
    func showTransformers(_ transformerList: [ShowTransformer.Display.Transformer]) {
        transformers = transformerList
        table.reloadData()
    }
    
    func createTransformer() {
        present(UIViewController.named("CreateTransformer"), animated: true) {
            self.interactor?.getTransformers()
        }
    }
}

//------------------------------------------------------------------------------
// MARK: View Controller
//------------------------------------------------------------------------------
class ShowTransformersVC : UIViewController {
    @IBOutlet weak var table: UITableView!
    var transformers:[ShowTransformer.Display.Transformer]? = nil
    
    
    override func viewDidLoad() {
        table.dataSource = self
        table.delegate = self
        interactor?.getTransformers()
    }
    
    //------------------------------------------------------------------------------
    // MARK: View Setup
    //------------------------------------------------------------------------------
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
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

//------------------------------------------------------------------------------
// MARK: TableView
//------------------------------------------------------------------------------
extension ShowTransformersVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = transformers?.count, count > 0 else { return 1 }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let count = transformers?.count, count > 0 else { return 170 }
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let count = transformers?.count, count > 0, let transformer = transformers?[indexPath.row],
            let cell = table.dequeueReusableCell(withIdentifier: "\(transformer.teamName)Cell")
            else { let emptyCell =  table.dequeueReusableCell(withIdentifier: "EmptyCell")
                as! EmptyCell
                emptyCell.delegate = {
                    self.createTransformer()
                }
                return emptyCell
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

class TransformerCell : UITableViewCell {
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    func setup(_ name:String, image:UIImage, rating:Int) {
        let imageView = UIImageView(frame: imageContainer.bounds)
        imageView.image = image
        imageContainer.addSubview(imageView)
        self.name.text = name
        self.rating.text = "\(rating)"
    }
}

class EmptyCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var createButton: UIButton!
    @IBAction func createTransformer(_ sender: Any) {
        createButton.isEnabled = false
        delegate?()
    }

    var delegate:(()->Void)? = nil
    func setCallBack(_ callback:@escaping ()->Void) {
        delegate = callback
    }
}

extension UITableViewCell {
    func applyShadowToCell() {
        self.layer.shadowColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 0.13).cgColor
        self.layer.shadowOffset =  CGSize(width: 0, height: 8)
        self.layer.shadowRadius = 16.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

