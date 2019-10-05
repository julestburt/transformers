//
//  ShowTransformersVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit
import Kingfisher

//------------------------------------------------------------------------------
// MARK: View Display
//------------------------------------------------------------------------------
protocol ShowTransformersDisplay {
    func showTransformers(_ transformerList:[ShowTransformer.Display.Transformer])
}

extension ShowTransformersVC : ShowTransformersDisplay {
    func showTransformers(_ transformerList: [ShowTransformer.Display.Transformer]) {
        transformers = transformerList
        //spinner off here
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    @objc func createTransformer() {
        present(UIViewController.named("CreateTransformer"), animated: true) {
        }
    }
}

//------------------------------------------------------------------------------
// MARK: View Controller
//------------------------------------------------------------------------------
class ShowTransformersVC : UIViewController {
    @IBOutlet weak var table: UITableView!
    var transformers:[ShowTransformer.Display.Transformer]? = nil
    var presentlySelected = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getTransformers()
    }

    //------------------------------------------------------------------------------
    // MARK: View Setup
    //------------------------------------------------------------------------------
    override func viewDidLoad() {
        table.dataSource = self
        table.delegate = self
        navigationItem.title = "Transformers"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Battle", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startBattle))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createTransformer))
    }
    
    
    @objc func startBattle() {
        present(UIViewController.named("BattleTransformers"), animated: true) {
            print("Battling...")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    var interactor:ShowTransformersLogic? = nil
    func setup() {
        let viewController = self
        let interactor = ShowTransformersInteractor()
        let presenter = ShowTransformersPresenter()
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
        return count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let count = transformers?.count, count > 0 else { return 170 }
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let count = transformers?.count, count > 0 && indexPath.row != count, let transformer = transformers?[indexPath.row],
            let cell = table.dequeueReusableCell(withIdentifier: "TransformerCell") as? TransformerCell
            else { let emptyCell =  table.dequeueReusableCell(withIdentifier: "EmptyCell" )
                as! EmptyCell
                emptyCell.createButton.isHidden = transformers != nil   
                emptyCell.creating = false
                emptyCell.delegate = {
                    self.createTransformer()
                }
                return emptyCell
        }
        print(transformer.teamName)
        cell.setup(transformer.name, image: transformer.imageURL, rating: transformer.rating)
        //        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let id = self.transformers?[indexPath.row].ID {
                Current.apiService?.delete(id)
                    .then { confirm in
                        Transformers.current.removeTransformer(id)
                        DispatchQueue.main.async {
                            self.transformers?.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .left)
                        }
                }.onError { error in
                    let error = error as? CustomError
                    print(error?.title ?? "")
                    print(error?.errorDescription)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !presentlySelected, let count = transformers?.count, indexPath.row < count,
        let transformer = transformers?[indexPath.row]
        else { return }
        Current.editTransformer = transformer.ID
        show(editTransformer, sender: nil)
    }
    
    var editTransformer:UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CreateTransformer")
    }

}

//------------------------------------------------------------------------------
// MARK: UITableViewCells
//------------------------------------------------------------------------------
class TransformerCell : UITableViewCell {
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    func setup(_ name:String, image:String, rating:String) {
        let imageView = UIImageView(frame: imageContainer.bounds)
        let url = URL(string: image)
        _ = imageContainer.subviews.map { $0.removeFromSuperview() }
        imageView.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage])
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
    var creating = false
    @IBAction func createTransformer(_ sender: Any) {
        guard !creating else { return }
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

