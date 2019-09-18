//
//  LoginInteractor.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-13.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

//------------------------------------------------------------------------------
// MARK: Login Interactor Logic
//-----------------------------------------------------------------------------=
protocol LoginInteractorLogic {
    func getSpark()
}

//------------------------------------------------------------------------------
// MARK: Login Interactor
//------------------------------------------------------------------------------
class LoginInteractor : LoginInteractorLogic {
    var presenter:LoginPresenterLogic? = nil
    func getSpark() {
        Current.apiService?.getAllSpark()
            .then { token in
                Current.user = User(token)
                self.presenter?.confirmLogin(true, error: nil)
            }
            .onError { (error) in
                print("error:\(error.localizedDescription)")
                self.presenter?.confirmLogin(false, error: "\(error.localizedDescription)")
        }
    }
}
