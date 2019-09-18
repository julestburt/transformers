//
//  LoginVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit
import Alamofire

//------------------------------------------------------------------------------
// MARK: LoginView Actions
//------------------------------------------------------------------------------
protocol LoginDisplay {
    func didLogin()
    func failedLogin(_ msg:String)
}

extension LoginVC : LoginDisplay {
    func didLogin() {
        gettingSpark = false
        show(transformers)
    }
    func failedLogin(_ msg: String) {
        print("error logging in - \(msg)")
        // display Error msg here!
        gettingSpark = false
    }
    
    @IBAction func getSpark(_ sender: UIButton) {
        guard !gettingSpark else { return }
        gettingSpark = true
        interactor?.getSpark()
    }
}

//------------------------------------------------------------------------------
// MARK: Login VC
//------------------------------------------------------------------------------
class LoginVC : UIViewController{
    @IBOutlet weak var getSparkButton: UIButton!
    var gettingSpark:Bool = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var interactor:LoginInteractorLogic?
    func setup() {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewController
    }

    var transformers:UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ShowTransformers")
    }

}
