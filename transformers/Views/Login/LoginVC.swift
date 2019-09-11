//
//  LoginVC.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import UIKit

protocol LoginDisplay {
    func didLogin()
    func failedLogin(_ msg:String)
}

extension LoginVC : LoginDisplay {
    func didLogin() {
        gettingSpark = false
        show(transformers)
//        dismiss(animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    func failedLogin(_ msg: String) {
        print("error logging in - \(msg)")
        gettingSpark = false
    }
}

class LoginVC : UIViewController{
    
    @IBOutlet weak var getSparkButton: UIButton!
    override func viewDidLoad() {
        //
    }
    
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
        guard !gettingSpark else { return }
        gettingSpark = true
        interactor?.getSpark()
    }
}

protocol LoginInteractorLogic {
    func getSpark()
}

class LoginInteractor : LoginInteractorLogic {
    var presenter:LoginPresenterLogic? = nil
    func getSpark() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).asyncAfter(deadline: .now() + 2) {
            // got token?
            _ = User.createTestUser
            self.presenter?.confirmLogin(true, error: nil)
        }
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
