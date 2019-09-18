//
//  LoginInteractorTests.swift
//  transformersTests
//
//  Created by Jules Burt on 2019-09-17.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import XCTest

@testable import transformers

class LoginInteractorTests: XCTestCase {
    
    var sut:LoginInteractor!
    var spy:LoginPresenterSpy!
    var window :UIWindow!
    var mockAPI = MockAPI()
    
    override func setUp() {
        super.setUp()
        setup()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setup() {
        spy = LoginPresenterSpy()
        sut = LoginInteractor()
        sut.presenter = spy
        User.clearStoredUser()
        Current.apiService = mockAPI
    }
    
    func testLoginAttempt() {
        sut.getSpark()
        sleep(1)
        XCTAssert(spy.confirmedLogin == true, "interactor failed to notify of successful login")
        mockAPI.allSparkFail = true
        sut.getSpark()
        sleep(1)
        XCTAssert(spy.confirmedFail == true, "interactor failed to notify presenter of successful login")
    }
}

class LoginPresenterSpy : LoginPresenterLogic {
    var confirmedLogin = false
    var confirmedFail = false
    var failMsg:String? = nil
    func confirmLogin(_ success: Bool, error: String?) {
        if success {
            confirmedLogin = true
        } else {
            confirmedFail = true
            failMsg = error
        }
        
    }
    
}
