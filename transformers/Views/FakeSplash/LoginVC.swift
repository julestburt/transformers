//
//  LoginVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

class LoginVC : UIViewController {
    
    @IBOutlet weak var getSparkButton: UIButton!
    override func viewDidLoad() {
        //
    }
    
    func showTransformers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let login = storyboard.instantiateViewController(withIdentifier: "Login") as? LoginVC else { return }
        //    let nav = storyboard.instantiateViewController(withIdentifier: "ShowTransformersNavigation") as? LoginNavigationController else { return }
        //    nav.viewToPresent = { return login }
        show(login)
    }

    @IBAction func getSpark(_ sender: Any) {
    }
}
