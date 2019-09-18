//
//  CreateTransformer.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

//------------------------------------------------------------------------------
// MARK: View Interactions
//------------------------------------------------------------------------------
protocol CreateTransformerDisplay {
    func showConfirmationCreated(_ transformerName:CreateTransformerModel.Created.CreatedTransformer)
    func failedToCreate()
}

extension CreateTransformerVC :CreateTransformerDisplay {
    func showConfirmationCreated(_ transformer:CreateTransformerModel.Created.CreatedTransformer) {
        
        let alertview = UIAlertController(title: "\(transformer.name) Created", message: "Success!! Get ready to fight...with 2 or more Transformers! Rating:\(transformer.rating)", preferredStyle: UIAlertController.Style.actionSheet)
        present(alertview, animated: true) {
            self.dismiss(animated: true, completion: {
                self.closeCreateView()
            })
        }
    }
    
    func closeCreateView() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func failedToCreate() {
        let alertview = UIAlertController(title: "Failed to Create", message: "Something failed on our end!?", preferredStyle: UIAlertController.Style.actionSheet)
        present(alertview, animated: true) {
            self.dismiss(animated: true, completion: {
                self.closeCreateView()
            })
        }
    }
}

//------------------------------------------------------------------------------
// MARK: View Controller & Setup
//------------------------------------------------------------------------------
class CreateTransformerVC : UIViewController , UIGestureRecognizerDelegate{
    var editExistingID:String? {
        return Current.editTransformer
    }
    // Creating a new Transformer sets this default property
    let DefaultValue = 5
    
    // initial testsetup
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var typeSelection: UISegmentedControl!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var valuesTable: UITableView!
    @IBOutlet weak var valuesTableHeight: NSLayoutConstraint!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    var transformerProperties:[String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupTransformerInView() {
        guard let editID = editExistingID, let editableTransformer = Transformers.current.transformerForID(editID) else {
            _ = TransformerProperties.map { transformerProperties[$0] = DefaultValue }
            typeSelection.selectedSegmentIndex = 0
            name.text = nil
            return
        }
        name.text = editableTransformer.name
        typeSelection.selectedSegmentIndex = editableTransformer.team == .autobot ? 0 : 1
        transformerProperties = [
            "strength" : editableTransformer.strength,
            "intelligence" : editableTransformer.intelligence,
            "speed" : editableTransformer.speed,
            "endurance" : editableTransformer.endurance,
            "rank" : editableTransformer.rank,
            "courage" : editableTransformer.courage,
            "firepower" : editableTransformer.firepower,
            "skill" : editableTransformer.skill
        ]
        
    }
    
    
    var tap:UITapGestureRecognizer?
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        self.name.endEditing(true)
    }
    
    func addTap() {
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        tap?.delegate = self
        tap?.cancelsTouchesInView = false
        view.addGestureRecognizer(tap!)
    }
    
    func removeTap() {
        if let tap = tap {
            view.removeGestureRecognizer(tap)
            self.tap = nil
        }
    }
    
    
    func setupView () {
        name.delegate = self
        setupTransformerInView()
        createButton.layer.cornerRadius = 5
        closeButton.layer.cornerRadius = closeButton.bounds.size.width / 2
        closeButton.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
        valuesTable.dataSource = self
        valuesTable.delegate = self
        valuesTable.reloadData()
    }
    
    var creatingAlready:Bool = false
    @IBAction func create(_ sender: UIButton) {
        guard !creatingAlready else { return }
        guard let name = name.text, name != "" else {
            let alertview = UIAlertController(title: "Need a Name", message: "Create a Transformer with a name!", preferredStyle: UIAlertController.Style.actionSheet)
            alertview.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated:true, completion: nil)
            }))
            present(alertview, animated: true, completion: nil)
            return
        }
        
        creatingAlready = true
        
        let request = CreateTransformerModel.Create.NewTransformer(name: name, team: typeSelection.selectedSegmentIndex == 0 ? Team.autobot.rawValue : Team.decepticon.rawValue, properties: transformerProperties)
        interactor?.createTransformer(request)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    
    
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
        let interactor = CreateTransformerInteractor()
        let presenter = CreateTransformerPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }
    
}

extension CreateTransformerVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        valuesTableHeight.constant = CGFloat(transformerProperties.count * 70 > 0 ? transformerProperties.count * 70 : 100)
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

extension CreateTransformerVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addTap()
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
        slider.setValue(setSliderLabel(Float(value)), animated: false)
    }
    
    @objc func changedSlider() {
        slider.setValue(setSliderLabel(slider.value), animated: true)
    }
    
    @objc func releasedSlider() {
        slider.setValue(setSliderLabel(slider.value), animated: true)
    }
    
    func setSliderLabel(_ value:Float) -> Float {
        let sliderIntValue = lroundf(value)
        sliderLabel.text = "\(sliderIntValue)"
        sendValue?(sliderIntValue)
        return value
    }
    
}
