//
//  LoginVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit
import Alamofire

protocol LoginDisplay {
    func didLogin()
    func failedLogin(_ msg:String)
}

extension LoginVC : LoginDisplay {
    func didLogin() {
        getSparkButton.isEnabled = true
        show(transformers)
    }
    func failedLogin(_ msg: String) {
        print("error logging in - \(msg)")
        // display Error msg here!
        getSparkButton.isEnabled = true
    }
}

class LoginVC : UIViewController{
    @IBOutlet weak var getSparkButton: UIButton!
    
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

    var gettingSpark:Bool = false
    @IBAction func getSpark(_ sender: UIButton) {
        sender.isEnabled = false
        interactor?.getSpark()
    }
}

protocol LoginInteractorLogic {
    func getSpark()
}

class LoginInteractor : LoginInteractorLogic {
    func getSpark() {
        getSpark(3)
    }
    
    var presenter:LoginPresenterLogic? = nil
    func getSpark(_ retries:Int = 3) {
//        FireBase.getAllSpark()
//            .then { token in
//                Current.user = User(token)
//                self.presenter?.confirmLogin(true, error: nil)  //Maybe?
//            }
//            .onError { (error) in
//                print("error:\(error.localizedDescription)")
//                self.presenter?.confirmLogin(false, error: "\(error.localizedDescription)")
//        }
    }
}

protocol LoginPresenterLogic {
    func confirmLogin(_ success:Bool, error:String?)
}

class LoginPresenter : LoginPresenterLogic {
    var view:LoginDisplay?
    func confirmLogin(_ success: Bool, error: String?) {
        success ? view?.didLogin() : view?.failedLogin(error ?? "no error?")
    }
}
