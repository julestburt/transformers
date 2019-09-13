//
//  LoginVCTests.swift
//  transformersTests
//
//  Created by Jules Burt on 2019-09-10.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import XCTest

@testable import transformers

class LoginVCTests: XCTestCase {

    var sut:LoginVC!
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
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "Login") as? LoginVC
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    func testLoginStart() {
        
        loadView()
        
        XCTAssert(sut.interactor != nil, "VC needs the interactor setup")
        sut.interactor?.getSpark()
        let interactorSpy = LoginInteractorSpy()
        sut.interactor = interactorSpy
        sut.getSpark(UIButton())
        XCTAssert(interactorSpy.getSParkCalled == true, "Pressing get AllSpark did not call the interactor method?")
    }
    
    func testLayout() {
        loadView()
        //        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }
}

class LoginInteractorSpy : LoginInteractorLogic {
    var getSParkCalled = false
    func getSpark() {
        getSParkCalled = true
    }
    
    
}
