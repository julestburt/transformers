//
//  User.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-17.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

//------------------------------------------------------------------------------
// MARK: Current user in environment. Token is stored away from the app logic
//------------------------------------------------------------------------------
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
    
    #if DEBUG
        static var token:String? {
        return UserDefaults.standard.string(forKey: defaults.userToken)
    }
    #else
        private static var token:String? {
        return UserDefaults.standard.string(forKey: defaults.userToken)
    }
    #endif

    
    static func existing() -> User? {
        guard let token = User.token else { return nil }
        return User(token)
    }
    
    init(_ token:String) {
        UserDefaults.standard.set(token, forKey: defaults.userToken)
        UserDefaults.standard.synchronize()
        // restore other user content here
    }
}
