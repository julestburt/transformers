//
//  FakeSplashVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

//------------------------------------------------------------------------------
// MARK:  Fake Splash Landing (Launchscreen) and app routing
//------------------------------------------------------------------------------

class FakeSplashVC: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        guard UserDefaults.standard.bool(forKey: UserDefaults.keys.isTesting) != true else { return }
        
        show ( Current.user == nil ? login : transformers )
    }

    var login:UIViewController {
       return UIViewController.named("Login")
    }
    
    var transformers:UIViewController {
        return UIViewController.named("ShowTransformers")
    }
    
}

