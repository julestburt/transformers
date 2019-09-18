//
//  EnvironmentTests.swift
//  transformersTests
//
//  Created by Jules Burt on 2019-09-10.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import XCTest
@testable import transformers

class EnvironmentTests: XCTestCase {
    var Current = Environment()
    var tokenRestore:String?
    override func setUp() {
        super.setUp()
        tokenRestore = User.token
        User.clearStoredUser()
    }

    override func tearDown() {
        if tokenRestore != nil {
            UserDefaults.standard.setValue(tokenRestore, forKey: defaults.userToken)
            UserDefaults.standard.synchronize()
        }
    }

    func testEnvironment() {
        XCTAssert(Current.apiService != nil, "Environment should come with the apiService setup")

        XCTAssert(Current.user == nil, "Environment shouldn't contain a user by default")
        XCTAssert(User.existing() == nil, "There should be no existing user without first creating one")
        XCTAssert(User.token == nil, "There should be no existing token without creating one")
        let createdUser = User.createTestUser
        XCTAssert(User.existing() != nil, "After creating a user there should be an exising user available")
        Current.user = createdUser
        XCTAssert(Current.user != nil, "Environment shouldn't contain a user by default")
    }


}
