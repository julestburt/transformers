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
    static var token:String? {
        return UserDefaults.standard.string(forKey: UserDefaults.keys.userToken)
    }
    
    static func existing() -> User? {
        guard let token = User.token else { return nil }
        return User(token)
    }
    
    init(_ token:String) {
        UserDefaults.standard.set(token, forKey: UserDefaults.keys.userToken)
    }
}

extension UserDefaults {
    enum keys {
        static let userToken = "userToken"
    }
}

