//
//  Environment.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

var Current = Environment()

struct Environment {
    var user:User? = {
        User.existing()
    }()
}

struct User {
    
    #if DEBUG
    static var createTestUser:User {
        return User.init("XXX TEST USER")
    }
    #endif
    
    private static var token:String? {
        return UserDefaults.standard.string(forKey: defaults.userToken)
    }
    
    static func existing() -> User? {
        guard let token = User.token else { return nil }
        return User(token)
    }
    
    private init(_ token:String) {
        UserDefaults.standard.set(token, forKey: defaults.userToken)
        // restore other user content here
    }
}

typealias defaults = UserDefaults.keys
extension UserDefaults {
    
    enum keys {
        static let userToken = "userToken"
    }
}

