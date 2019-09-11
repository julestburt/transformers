//
//  Endpoints.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-09.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

class FireBase {
    let api:APIService = API.service
    
    enum APIType:String {
        case POST
        case GET
    }
    struct Endpoint {
        let endpoint:String
        let type:APIType
    }
    static let getAllSpark = Endpoint(endpoint: "/allspark", type:APIType.GET)
    static let getTransformers = Endpoint(endpoint: "/transformers", type:APIType.GET)
    static let createTransformer = Endpoint(endpoint: "/transformers", type:APIType.POST)
    static let updateTransformer = Endpoint(endpoint: "/transformers", type:APIType.GET)
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
 
 import Foundation
 import then
 
 class WordPress {
 let api:APIService = API.service
 
 struct Endpoints {
 struct endpoint { let endpoint:String }
 
 static let getBlogPosts = endpoint(endpoint: "/posts?per_page={numberPostsPerPage}&page={pageNumber}")
 static let getkBasePosts = endpoint(endpoint: "/kbe_knowledgebase?per_page={numberPostsPerPage}&page={pageNumber}")
 static let getPostImages = endpoint(endpoint: "/media?per_page=25&include={csvIDs}")
 }
 
 func getPosts(_ type:ArticleType, pageNumber:Int, numberPostsPerPage:Int = 25) -> Promise<[BlogItem]> {
 return Promise<[BlogItem]> { resolve, reject in
 let getPosts = type == .blogPost ? Endpoints.getBlogPosts : Endpoints.getkBasePosts
 let url = getPosts.endpoint
 .replacingOccurrences(of: "{pageNumber}", with: "\(pageNumber)")
 .replacingOccurrences(of: "{numberPostsPerPage}", with: "\(numberPostsPerPage)")
 self.api.request(url, completion: { result in
 switch result {
 case .Success(let data):
 if let jsonArray = data.array {
 let items = BlogItem.createPostsFromArray(json:jsonArray)
 resolve(items)
 } else {
 print("JSON - empty?: \(data.stringValue)")
 }
 case .Error(let error, let code, let message):
 let errorMsg = "\(error):\(code):\(message)"
 reject(CustomError(title: "problem", description: errorMsg, code: 99))
 }
 })
 }
 }
 
 func getPostImages(_ imageIDs:[Int]) -> Promise<[BlogImageRef]> {
 return Promise<[BlogImageRef]> { resolve, reject in
 guard imageIDs.count > 0 else {
 resolve([])
 return
 }
 let getPostImages = Endpoints.getPostImages
 let IDs = imageIDs.reduce("", { (csvString, nextID) -> String in
 let separator = csvString != "" ? "," : ""
 return csvString + separator + String(nextID)
 })
 let url = getPostImages.endpoint.replacingOccurrences(of: "{csvIDs}", with: IDs)
 self.api.request(url, completion: { (result) in
 switch result {
 case .Success(let data):
 var blogPostImages:[BlogImageRef] = []
 if let jsonArray = data.array {
 for (eachEntryJSON) in jsonArray {
 if let id = eachEntryJSON["id"].int, let URL = eachEntryJSON["source_url"].string {
 let entry = BlogImageRef(id: id, URL: URL)
 blogPostImages.append(entry)
 } else {
 print("error processing blog images")
 }
 }
 } else {
 print("JSON - empty?: \(data.stringValue)")
 }
 resolve(blogPostImages)
 case .Error(let error, let code, let message):
 let errorMsg = "\(error):\(code):\(message)"
 reject(CustomError(title: "problem", description: errorMsg, code: 99))
 }
 })
 }
 }
 }

 
 */
