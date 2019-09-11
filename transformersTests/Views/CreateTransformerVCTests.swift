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

class CreateTransformerTests: XCTestCase {
    
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
        if let first = sut.transformerProperties.first {
            XCTAssert(first.rawValue == TransformerProperty.init(rawValue:TransformerProperties[0])!.rawValue, "Failed to find the first transformer value")
        }
        for (idx, eachProperty) in sut.transformerProperties.enumerated() {
                XCTAssert(eachProperty.rawValue == TransformerProperties[idx], "Failed to find all expected values")
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLayout() {
        loadView()
//        assertSnapshot(matching: sut, as: .image(on: .iPhone8))
    }

}
