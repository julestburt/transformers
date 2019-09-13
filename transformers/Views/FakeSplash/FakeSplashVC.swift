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
        show ( Current.user == nil ? login : transformers )
    }

    var login:UIViewController {
        return UIViewController.named("Login")
    }
    
    var transformers:UIViewController {
        return UIViewController.named("ShowTransformers")
    }
    
}

