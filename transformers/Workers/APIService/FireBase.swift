//
//  Endpoints.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation
import Alamofire
import then
import SwiftyJSON

class Endpoints  {
    private init?() {}
    static var allSpark:Endpoint { return Endpoint("/allspark", type:.get) }
    static var getTransformers:Endpoint { return Endpoint("/transformers", type:.get)}
    static var postTransformer:Endpoint { return Endpoint("/transformers", type:.post)}
    static var putTransformer:Endpoint { return Endpoint("/transformers", type:.put)}
    static var deleteTransformer:Endpoint { return Endpoint("/transformers/{transformersId}", type: .delete)}
}

struct Endpoint {
    let url:String
    let type:HTTPMethod
    init(_ url:String, type:HTTPMethod) {self.url = url ; self.type = type }
}

protocol APIProtocol {
    func getAllSpark() -> Promise<String>
    func getTransformers() -> Promise<[Transformer]>
    func createTransformer(_ name:String, team:String, properties:[String:Int]) -> Promise<Transformer>
    func changeTransformer(_ ID:String, name:String, team:String, properties:[String:Int]) -> Promise<Transformer>
    func delete(_ id:String) -> Promise<Bool>
}

class FireBase : APIProtocol {
    private let api:APIService = API.service
    
    func getAllSpark() -> Promise<String> {
        return Promise { success, fail in
            // If have a token just return it!
            if let token = User.token { success(token) ; return }
            let endpoint = Endpoints.allSpark
            API.service.request(url: endpoint.url, type:endpoint.type) { response in
                switch response {
                case .Success(let json):
                    if let token = json["token"].string {
                        success(token)
                    } else {
                        fail(CustomError(title: "Failed to get token", description: "couldn't extract from response data?", code: -97))
                    }
                case .Error(let error):
                    print(error.message)
                    fail(CustomError(title: error.error, description: error.message, code: error.code))
                }
            }
        }
    }
    
    func getTransformers() -> Promise<[Transformer]> {
        return Promise { success, fail in
            let endpoint = Endpoints.getTransformers
            API.service.request(url: endpoint.url, type: endpoint.type) { response in
                switch response {
                case .Success(let json):
                    let jsonArray = json["transformers"].array
                    let transformers = json["transformers"].arrayValue.compactMap { Transformer($0.description) }
                    success(transformers)
                case .Error(let error):
                    print(error.message)
                    fail(CustomError(title: error.error, description: error.message, code: error.code))
                }
            }
        }
    }
    
    func createTransformer(_ name:String, team:String, properties:[String:Int]) -> Promise<Transformer> {
        return Promise { success, fail in
            let endpoint = Endpoints.postTransformer
            var params = properties.reduce(into: [String:Any]()) { result, item in
                result[item.key] = item.value
            }
            params["name"] = name
            params["team"] = team
            API.service.request(url: endpoint.url, type: endpoint.type, params: params) { response in
                switch response {
                case .Success(let json):
                    print(json.string ?? "---")
                    if let transformer = Transformer(json.stringValue) {
                        Transformers.current.addCreatedTransformer(transformer)
                        success(transformer)
                    }
                    // Fall through case
                    Transformers.current.refreshFromServer()
                    fail(CustomError(title: "Failed to createTransformer", description: "couldn't extract from response data?", code: -97))
                case .Error(let error):
                    print(error.message)
                }
            }
        }
    }
    
    func changeTransformer(_ ID:String, name:String, team:String, properties:[String:Int]) -> Promise<Transformer> {
        return Promise { success, fail in
            let endpoint = Endpoints.postTransformer
            var params = properties.reduce(into: [String:Any]()) { result, item in
                result[item.key] = item.value
            }
            params["name"] = name
            params["team"] = team
            params["id"] = ID
            API.service.request(url: endpoint.url, type: endpoint.type, params: params) { response in
                switch response {
                case .Success(let json):
                    if let transformer = Transformer(json.stringValue) {
                        Transformers.current.addCreatedTransformer(transformer)
                        success(transformer)
                    }
                    fail(CustomError(title: "Failed to createTransformer", description: "couldn't extract from response data?", code: -97))
                case .Error(let error):
                    print(error.message)
                }
            }
        }
    }
    

    
    func delete(_ id:String) -> Promise<Bool> {
        return Promise { success, fail in
            let endpoint:Endpoint = Endpoints.deleteTransformer
            API.service.request(url: endpoint.url.replacingOccurrences(of: "{transformersId}", with: id), type: endpoint.type) { response in
                switch response {
                case .Success(let json):
                    print(json.description)
                    success(true)
                case .Error(let error):
                    print(error.message)
                    fail(CustomError(title: error.error, description: error.message, code: error.code))
                }
            }
            return
        }
    }
}


protocol OurErrorProtocol: LocalizedError {
    var title: String? { get }
    var code: Int { get }
}

struct CustomError: OurErrorProtocol {
    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    private var _description: String
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}


/*
 GET https://transformers-api.firebaseapp.com/allspark
 “Authorization” “Bearer <token>”\
 “Content-Type” “application/json”
 POST ​https://transformers-api.firebaseapp.com/transformers
 {
 "name": "Megatron", "strength": 10, "intelligence": 10, "speed": 4, "endurance": 8, "rank": 10, "courage": 9, "firepower": 10, "skill": 9,
 "team": "D"
 }
 
 GET ​https://transformers-api.firebaseapp.com/transformers
 {
 "transformers": [
 {...
 
 PUT ​https://transformers-api.firebaseapp.com/transformers
 {
 "id": "-LLbrUN3dQkeejt9vTZc",
 "name": "Megatron123",
 ...
 
 DELETE ​https://transformers-api.firebaseapp.com/transformers/{transformerId}
 ...
 
 */
