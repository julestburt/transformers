//
//  CreateTransformer.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit



class CreateTransformerVC : UIViewController {
    
    // initial testsetup
    @IBOutlet weak var typeSelection: UISegmentedControl!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var valuesTable: UITableView!
    @IBOutlet weak var createButton: UIButton!
    var transformerProperties:[TransformerProperty] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView () {
        
        transformerProperties = TransformerProperties
            .compactMap { TransformerProperty.init(rawValue: $0) }
        
        typeSelection.selectedSegmentIndex = 0
        
        name.text = nil
        
        valuesTable.dataSource = self
        valuesTable.delegate = self
    }
    @IBAction func create(_ sender: UIButton) {
    }
}

extension CreateTransformerVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transformerProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell") as? SliderCell else {
            return UITableViewCell() }
        
        let property = transformerProperties[indexPath.row]
        cell.setup(property.rawValue, value: 5)
        return cell
    }
    
    
}


class SliderCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    func setup(_ titleText:String, value:Int) {
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
        return sliderValue
    }

}
