//
//  transformersTests.swift
//  transformersTests
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import XCTest
//import SnapshotTesting

@testable import transformers

class CreateTransformerTestsVC: XCTestCase {
    
    var sut:CreateTransformerVC!
    var window :UIWindow!

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupCreateTransformerVC()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        window = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func setupCreateTransformerVC() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "CreateTransformer") as? CreateTransformerVC
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    func testViewStart() {
        loadView()
        
        for eachProperty in TransformerProperties {
                XCTAssert(sut.transformerProperties[eachProperty] == 5, "Failed to find all default values")
        }
        XCTAssert(sut.createButton.isEnabled == true, "Create button wasn't enabled")
        let spy = spyCreateTransformerInteractor()
        sut.interactor = spy
        let spyName = "MegaTest"
        let teamSelection = 1
        sut.name.text = spyName
        sut.typeSelection.selectedSegmentIndex = teamSelection
        sut.create(sut.createButton)    // Mock user pressing button
        XCTAssert(spy.didSelectCreateTransformer == true, "CreateVC did not call the interactor when Create button pressed")
        XCTAssert(spy.name == spyName, "Created Name wasn't passed in the request to Create?")
        XCTAssert(spy.team == Team(rawValue: teamSelection == 0 ? "A" : "D")!.rawValue, "Created Name wasn't passed in the request to Create?")
    }
    
    func testInitialDesignLayout() {
        loadView()
//        record = true
//        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }

}

class spyCreateTransformerInteractor: CreateTransformerInteractorLogic {
    var didSelectCreateTransformer = false
    var name:String? = nil
    var team:String? = nil
    var properties:[String:Int]? = nil
    
    func createTransformer(_ request: CreateTransformerModel.Create.NewTransformer) {
        didSelectCreateTransformer = true
        self.name = request.name
        self.team = request.team
        self.properties = request.properties

    }
}
