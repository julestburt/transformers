//
//  Environment.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

//------------------------------------------------------------------------------
// MARK: Dependency injected  Global App State
//      Allowing for mocks of API, user access etc.
//      Also can help manage/test with access to Date, random etc
//------------------------------------------------------------------------------
var Current = Environment()

struct Environment {
    var user:User? = {
        User.existing()
    }()
    var apiService:APIProtocol? = FireBase()   // MockAPI()
    var editTransformer:String? = nil
}

