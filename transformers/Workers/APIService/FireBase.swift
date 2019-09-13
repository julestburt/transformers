//
//  Endpoints.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation
import Alamofire
//import then

class FireBase {
    let api:APIService = API.service
    
    struct Endpoint {
        let url:String
        let type:HTTPMethod
        init(_ url:String, type:HTTPMethod) { self.url = url ; self.type = type}
    }
    
    private static let allSpark = Endpoint("/allspark", type:.get)
    private static let getTransformers = Endpoint("/transformers", type:.get)
    private static let postTransformer = Endpoint("/transformers", type:.post)
    private static let putTransformer = Endpoint("/transformers", type:.put)
    private static let deleteTransformer = Endpoint("/transformers/{transformersId}", type: .delete)
    
    static func getAllSpark(_ endpoint:Endpoint = allSpark) {}
    static func getAllSpark() /*Promise<String>*/ {
//        let this = Promise { success, fail in
//            let endpoint = allSpark
//            API .service.request(url: endpoint.url, type:endpoint.type) -> ()-Void return { response in
//                switch response {
//                case .Success(let json):
//                    if let token = json["token"].string {
////                        success(token)
//                    } else {
////                        fail(CustomError(title: "Failed to get token", description: "couldn't extract token from response data?", code: -97))
//                    }
//                case .Error(let error):
//                    print(error.message)
//                    fail(CustomError(title: error.error, description: error.message, code: error.code))
//                }
//            }
    }
    
    static func getTransformers(_ completion:@escaping (String)->Void) {
        let endpoint = getTransformers
        API.service.request(url: endpoint.url, type: endpoint.type) { response in
            switch response {
            case .Success(let json):
                print(json)
                completion(json.description)
                
            case .Error(let error):
                print(error.message)
            }
        }
    }
    
    static func createTransformer(_ name:String, team:String, properties:[String:Int], completion:@escaping (String)->Void) {
        let endpoint = postTransformer
        var params = properties.reduce(into: [String:Any]()) { result, item in
            result[item.key] = item.value
        }
        params["name"] = name
        params["team"] = team
        API.service.request(url: endpoint.url, type: endpoint.type, params: params) { response in
            switch response {
            case .Success(let json):
                print(json)
                completion(json.description)
            
            case .Error(let error):
            print(error.message)
            }
        }
    }
    
    static func updateTransformer(_ transformer:Transformer, completion:@escaping (String)->Void) {
        guard let transformerJSON = transformer.createJSON else { return }
        let endpoint = putTransformer
        API.service.request(url: endpoint.url, type: endpoint.type) { response in
            switch response {
            case .Success(let json):
                print(json)
                completion(json.description)
                
            case .Error(let error):
                print(error.message)
            }
        }
    }
    
    static func deleteTransformer(_ transformer:Transformer, completion:@escaping (String)->Void) {
        guard let transformerJSON = transformer.createJSON else { return }
        let endpoint:Endpoint = deleteTransformer
        return
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
 
