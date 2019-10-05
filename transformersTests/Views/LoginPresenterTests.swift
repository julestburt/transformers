//
//  LoginPresenterTests.swift
//  transformersTests
//
//  Created by Jules Burt on 2019-09-16.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import XCTest
//import SnapshotTesting

@testable import transformers

class LoginPresenterTests: XCTestCase {
    
    var sut:LoginPresenter!
    var spy:LoginViewSpy!
    var window :UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setup()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func setup() {
        spy = LoginViewSpy()
        sut = LoginPresenter()
        sut.view = spy
    }
    
    func testLoginPresentSuccess() {
        sut.confirmLogin(true, error: nil)
        XCTAssert(spy.didLoginConfirm == true, "presenter did not Confirm Login")
        sut.confirmLogin(false, error: "problem logging in")
        XCTAssert(spy.didLoginFail, "presenter did not Fail login")
        
        XCTAssert(spy.message ?? "" == "problem logging in", "presenter did not get message")
    }
    
}

class LoginViewSpy : LoginDisplay {
    var didLoginConfirm = false
    func didLogin() {
        didLoginConfirm = true
    }
    
    var didLoginFail = false
    var message:String? = nil
    func failedLogin(_ msg: String) {
        message = msg
        didLoginFail = true
    }
}
