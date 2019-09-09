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
    
    var transformerProperties:[TransformerProperty] = []
    
    @IBOutlet weak var settingsView: UIStackView!
    
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
        _ = transformerProperties
            .map { property in
            let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize.init(width: 50, height: 50)))
                label.text = property.rawValue
                return label
            }
            .map { settingsView.addArrangedSubview($0) }
    }


}

