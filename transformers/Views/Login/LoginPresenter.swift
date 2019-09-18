//
//  LoginPresenter.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-13.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

//------------------------------------------------------------------------------
// MARK: Login Presenter Logic
//------------------------------------------------------------------------------
protocol LoginPresenterLogic {
    func confirmLogin(_ success:Bool, error:String?)
}

//------------------------------------------------------------------------------
// MARK: Login Presenter - a simple pass through, but anables testing!
//------------------------------------------------------------------------------
class LoginPresenter : LoginPresenterLogic {
    var view:LoginDisplay?
    func confirmLogin(_ success: Bool, error: String?) {
        success ? view?.didLogin() : view?.failedLogin(error!)
    }
}
