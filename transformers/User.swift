//
//  User.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-17.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

struct User {
    
    #if DEBUG
    static var createTestUser:User {
        return User.init("XXX TEST USER")
    }
    
    static func clearStoredUser() {
        guard let _ = Current.user else {
            return }
        UserDefaults.standard.removeObject(forKey: defaults.userToken)
        UserDefaults.standard.synchronize()
        Current.user = nil
        print("User deleted")
    }
    #endif
    
    static var token:String? {
        return UserDefaults.standard.string(forKey: defaults.userToken)
    }

    static func existing() -> User? {
        guard let token = User.token else { return nil }
        return User(token)
    }
//    var exists:Bool {
//        return User.token != nil
//    }
    
    init(_ token:String) {
        UserDefaults.standard.set(token, forKey: defaults.userToken)
        UserDefaults.standard.synchronize()
        // restore other user content here
    }
}
