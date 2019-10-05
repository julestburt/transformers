//
//  LoginVCTests.swift
//  transformersTests
//
//  Created by Jules Burt on 2019-09-10.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import XCTest
//import SnapshotTesting

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
        XCTAssert(sut.interactor != nil, "View failed to setup the interacto")
        let interactorSpy = LoginInteractorSpy()
        sut.interactor = interactorSpy
        sut.getSpark(UIButton())
        XCTAssert(interactorSpy.getSparkCalled == true, "Pressing get AllSpark did not call the interactor method?")
        interactorSpy.getSparkCalled = false
        sut.getSpark(UIButton())
        XCTAssert(interactorSpy.getSparkCalled == false, "De-bounce for input seems to have failed")
    }
    
    func testLoginCreateShowTransformersView() {
        loadView()
        XCTAssert(sut.restorationIdentifier! == "Login", "did not get expected next View Controller")
    }
    
    func testLayout() {
        loadView()
//        record = true
//        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }
}

class LoginInteractorSpy : LoginInteractorLogic {
    var getSparkCalled = false
    func getSpark() {
        getSparkCalled = true
    }
}
