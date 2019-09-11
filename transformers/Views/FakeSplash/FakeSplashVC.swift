//
//  FakeSplashVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

class FakeSplashVC: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        let startView = Current.user != nil ?
            transformers : login
        self.show(startView)
    }

    var login:UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "Login")
    }
    
    var transformers:UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ShowTransformers")
    }
    
}
