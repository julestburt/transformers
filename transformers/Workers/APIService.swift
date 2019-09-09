//
//  APIService.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-08.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol APIResponse {
    func didReceive(tag:String, result: JSON)
    func didFail(tag:String, error:String, code:Int?)
}

protocol APIService {
    func request(tag:String, url:String, completion:@escaping jsonCompletion)
}

typealias jsonCompletion = ((APIDataResult<NSData>)->())
enum APIDataResult<T> {
    case Success(data:JSON)
    case Error((error:String, code:Int, message:String))
}

let serviceURL = "​https://transformers-api.firebaseapp.com"

class API : NSObject, APIService {
    
    private static var _instance: API?
    
    class var service:API {
        if _instance == nil {
            _instance = API()
        }
        return _instance!
    }
    
    fileprivate(set) var alamoFire:SessionManager!
    var currentRequests:[String:APIRequest] = [:]
    
    fileprivate var APIcompletions = [((APICompletionResult<NSData>) -> Void)?]()
    enum APICompletionResult<T> {
        case Success((service:API, tag:String, result:JSON))
        case Error((error:String, code:Int, message:String))
    }
    
    override init() {
        super.init()
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20
        sessionConfig.timeoutIntervalForResource = 60
        alamoFire = Alamofire.SessionManager(configuration: sessionConfig)
    }

    func request(tag:String, url:String, completion:@escaping jsonCompletion) {
        return requestWithRetries(tag: tag, url: url, completion:completion)
    }
    
    func requestWithRetries(tag:String, url:String, maxRetry:Int = 3, completion:@escaping jsonCompletion) {
        var headers = [String:String]()
        let params = [String:AnyObject]()
        let token = "UNVCRDFR5M8BW0P72KU6"
        headers["Authorization"] = token

       let alamoRequest = alamoFire.request(serviceURL + url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers) .validate() .responseJSON { response in
            
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let result = JSON(json)
                    if let serverMessage = result["message"].string {
                        self.didFail(tag: tag, error: serverMessage, code: nil)
                        return
                    }
                    self.saveDebugData(result.description, fileName: tag)
                    self.didReceive(tag: tag, result: result)
                }
            case .failure(_):
                break
            }
        }
        let request = APIRequest(tag:tag, url:url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers, retryCount:maxRetry, request: alamoRequest, completion:completion)
        currentRequests[tag] = request
    }
    

    private let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    func saveDebugData(_ sourceString:String, fileName:String) {
        
        #if DEBUG
        let fileNamePath = documentsPath.appendingPathComponent(fileName+".txt")
        do {
            
            try sourceString.write(toFile: fileNamePath, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("error saving file \(fileNamePath)")
            print(error.localizedDescription)
        }
        #endif
    }

}

extension API : APIResponse {
    func didReceive(tag: String, result: JSON) {
        print(result)
        
    }
    
    func didFail(tag: String, error: String, code: Int?) {
        print("Error:\(error), \(code != nil ? String(code!) : "") - \(tag)")
    }
    
    
}

enum APIRequestMethod {
    case get, post
}

class APIRequest: NSObject {
    let ID:String
    let tag:String
    let url:String
    let method:APIRequestMethod
    let encoding:ParameterEncoding
    let headers:[String:String]
    let params:[String:AnyObject]
    var retryCount:Int = 0
    let request:DataRequest
    let completion:jsonCompletion
    
    init(tag:String, url:String, method:APIRequestMethod, parameters:[String:AnyObject], encoding:ParameterEncoding, headers:[String:String], retryCount:Int, request:DataRequest, completion:@escaping jsonCompletion) {
        self.ID = UUID().uuidString
        self.tag = tag
        self.url = url
        self.method = method
        self.encoding = encoding
        self.headers = headers
        self.params = parameters
        self.retryCount = retryCount
        self.request = request
        self.completion = completion
    }
}

