//
//  MockAPI.swift
//  transformersTests
//
//  Created by Jules Burt on 2019-09-18.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation
import then

@testable import transformers

class MockAPI : APIProtocol {
    
    var allSparkFail = false
    var transformers:[Transformer]?
    var createTransformer:Transformer?
    var id:String?
    
    func getAllSpark() -> Promise<String> {
        return Promise { success, fail in
            if self.allSparkFail {
                fail(CustomError(title: "Failing for Test", description: "Forced Fail for Testing", code: -95))
            } else {
                success( "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cmFuc2Zvcm1lcnNJZCI6Ii1Mb1RvVEVsZENqQm5aQTJycUowIiwiaWF0IjoxNTY4MTgwMTM0fQ.G0VrPMTpd5zQMlKVr1w3cHExXHgN0GIE01I62a5VSUs")
            }
        }
    }
    
    func getTransformers() -> Promise<[Transformer]> {
        return Promise { success, fail in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                success(self.transformers ?? [])
            }
        }
    }
    
    func createTransformer(_ name: String, team: String, properties: [String : Int]) -> Promise<Transformer> {
        return Promise { success, fail in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                var  defaultTransformer:Transformer { let uuid = UUID.init().uuidString
                    let prefix = uuid.prefix(5)
                    let randomTeam = Float.random(in: 0..<1) == 0 ? Team.autobot : Team.decepticon
                    return Transformer.makeTransformer(name: "name-\(prefix)", id: uuid, team: randomTeam)
                }
                
                let createdTransformer = self.createTransformer ?? defaultTransformer
                
                success(createdTransformer)
            }
        }
    }
    
    func delete(_ id:String) -> Promise<Bool> {
        return Promise { success, fail in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                success(true)
            }
        }
    }
}
