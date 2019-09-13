//
//  CreateTransformer.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

protocol CreateTranformerDisplay {
    func showConfirmationCreated(_ transformerName:String)
}

extension CreateTransformerVC :CreateTranformerDisplay {
    func showConfirmationCreated(_ transformerName:String) {
        let alertview = UIAlertController(title: "Transformer Created", message: "Success!! Get ready to fight...with 2 or more Transformers!", preferredStyle: UIAlertController.Style.actionSheet)
        present(alertview, animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

class CreateTransformerVC : UIViewController {
    
    // Creating a new Transformer sets this default property
    let DefaultValue = 5

    // initial testsetup
    @IBOutlet weak var typeSelection: UISegmentedControl!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var valuesTable: UITableView!
    @IBOutlet weak var createButton: UIButton!
    var transformerProperties:[String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView () {
        _ = TransformerProperties.map { transformerProperties[$0] = DefaultValue}
        typeSelection.selectedSegmentIndex = 0
        name.text = nil
        valuesTable.dataSource = self
        valuesTable.delegate = self
    }
    @IBAction func create(_ sender: UIButton) {
        guard let name = name.text, name != "" else {
            // display error
            return
        }
        createButton.isEnabled = false
        
        let request = CreateTransformerModel.Create.NewTransformer(name: name, team: typeSelection.selectedSegmentIndex == 0 ? Team.autobot.rawValue : Team.decepticon.rawValue, properties: transformerProperties)
        interactor?.createTransformer(request)
    }
    
    //------------------------------------------------------------------------------
    // MARK: View Controller
    //------------------------------------------------------------------------------

    
    
    //------------------------------------------------------------------------------
    // MARK: Setup
    //------------------------------------------------------------------------------

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var interactor:CreateTransformerInteractorLogic?
    func setup() {
        let viewController = self
        let interactor = CreateTranformerInteractor()
        let presenter = CreateTranformerPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }

}
protocol CreateTransformerInteractorLogic {
    func createTransformer(_ request:CreateTransformerModel.Create.NewTransformer) -> Transformer?
}

class CreateTranformerInteractor : CreateTransformerInteractorLogic{

    var presenter:CreateTranformerPresenterLogic? = nil
    func createTransformer(_ request: CreateTransformerModel.Create.NewTransformer) -> Transformer? {
        FireBase.createTransformer(request.name, team: request.team, properties: request.properties) { jsonString in
            print(jsonString)
        }
        FireBase.createTransformer(request.name, team: request.team, properties: request.properties) { jsonString in
            print(jsonString)
        }
        return nil
    }
    
    
}
protocol CreateTranformerPresenterLogic {
    func confirmTransformerCreated(_ name:String)
}
class CreateTranformerPresenter : CreateTranformerPresenterLogic{
    var view:CreateTranformerDisplay? = nil
    func confirmTransformerCreated(_ name:String) {
        view?.showConfirmationCreated(name)
    }
}

extension CreateTransformerVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transformerProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let propertyName = TransformerProperties[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell") as? SliderCell,
            let propertyValue = transformerProperties[propertyName]
            else { return UITableViewCell() }
        cell.setup(propertyName, value: propertyValue) { newValue in
            self.transformerProperties[propertyName] = newValue
        }
        return cell
    }
    
    
}


class SliderCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    var sendValue:((Int)->Void)? = nil
    
    func setup(_ titleText:String, value:Int, changed:@escaping (Int)->Void) {
        sendValue = changed
        title.text = titleText
        slider.isContinuous = true
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(changedSlider), for: UIControl.Event.valueChanged)
        slider.addTarget(self, action: #selector(releasedSlider), for: UIControl.Event.touchUpInside)
        slider.setValue(Float(value), animated: false)
    }
    
    @objc func changedSlider() {
        _ = setSliderLabel(slider.value)
    }

    @objc func releasedSlider() {
        slider.setValue(Float(setSliderLabel(slider.value)), animated: true)
    }

    func setSliderLabel(_ value:Float) -> Int {
        let sliderValue = lroundf(slider.value)
        sliderLabel.text = "\(Int(sliderValue))"
        sendValue?(sliderValue)
        return sliderValue
    }

}
