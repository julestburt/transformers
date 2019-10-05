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

//------------------------------------------------------------------------------
// MARK: Firebase Service
//------------------------------------------------------------------------------
let serviceURL = "https://transformers-api.firebaseapp.com"

protocol APIService {
    func request(url:String, type:HTTPMethod, params:[String:Any]?, completion:@escaping jsonCompletion)
}

extension API : APIService {
    func request(url:String, type:HTTPMethod, params:[String:Any]? = nil, completion:@escaping jsonCompletion) {
        guard let URL = URL(string: "\(serviceURL)\(url)")
            else { completion(.Error((error:"invalidIURL", code:-99, message:"request couldn't be started")))
                return }
        let newID = UUID.init().uuidString
        return requestWithRetries(ID: newID, url: URL, params:params, type:type, completion:completion)
    }
}

//------------------------------------------------------------------------------
// MARK: Requests
//------------------------------------------------------------------------------
protocol APIResponse {
    func didReceive(tag:String, result: JSON)
    func didFail(tag:String, error:String, code:Int?)
}

typealias jsonCompletion = ((APIDataResult<NSData>)->())
enum APIDataResult<T> {
    case Success(data:JSON)
    case Error((error:String, code:Int, message:String))
}

class API : NSObject {
    private static var _instance: API?
    
    class var service:API {
        if _instance == nil {
            _instance = API()
        }
        return _instance!
    }
    
    fileprivate(set) var alamoFire:SessionManager!
    
    private var APIcompletions = [((APICompletionResult<NSData>) -> Void)?]()
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
    
    private func requestWithRetries(ID:String, url:URL, params:[String:Any]?, maxRetry:Int = 3,  type:HTTPMethod, completion:@escaping jsonCompletion) {
        guard let _ = User.token else {
            requestUnauthorized(ID, url, maxRetry, type, completion)
            return
        }
        requestAuthorized(ID, url, params, maxRetry, type, completion)
    }
    
    fileprivate func requestUnauthorized(_ ID: String, _ url: URL, _ maxRetry:Int, _ type:HTTPMethod, _ completion:@escaping jsonCompletion) {
        var headers:[String:String]? = [:]
        headers?["Content-Type"] = "application/json"
        let alamoRequest = alamoFire.request(url, method: type, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
            switch response.result {
            case .success(_):
                if let token = response.result.value {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                        let result: JSON =  ["token":"\(token)"]
                        self.didReceive(ID: ID, result: result)                    }
                }
            case .failure(_):
                self.didFail(ID: ID, error: "failed to get token", code: -98)
            }
            
        }
        addToRequestQueue(alamoRequest, ID, url, nil, headers, maxRetry, type, completion)
    }
    
    fileprivate func requestAuthorized(_ ID:String, _ url:URL, _ params:[String:Any]?, _ maxRetry:Int = 3, _ type:HTTPMethod, _ completion:@escaping jsonCompletion) {
        var headers:[String:String]? = [:]
        headers?["Content-Type"] = "application/json"
        headers?["Authorization"] = User.token != nil ? "Bearer \(User.token!)" : nil// "Bearer <\(User.token!)>" : nil
        let alamoRequest = alamoFire.request(url.description, method: type, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    print(json)
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                        let result = JSON(json)
                        self.didReceive(ID: ID, result: result)
                    }
                }
            case .failure(let error):
                let (errorMsg, code) = self.handleError(error)
                self.didFail(ID: ID, error: errorMsg, code: code)
            }
        }
        addToRequestQueue(alamoRequest, ID, url, params, headers, maxRetry, type, completion)
    }
    
    func handleError(_ error:Error) -> (String, Int?) {
        var errorMessage:String = ""
        var errorCode:Int?
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                errorMessage = "Invalid URL: \(url) - \(error.localizedDescription)"
            case .parameterEncodingFailed(let reason):
                errorMessage = "Parameter encoding failed: \(error.localizedDescription)"
                errorMessage += " - Failure Reason: \(reason)"
            case .multipartEncodingFailed(let reason):
                errorMessage = "Multipart encoding failed: \(error.localizedDescription)"
                errorMessage += "- Failure Reason: \(reason)"
            case .responseValidationFailed(let reason):
                errorMessage = "Response validation failed: \(error.localizedDescription)"
                errorMessage += " - Failure Reason: \(reason)"
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    errorMessage += ", Downloaded file could not be read"
                case .missingContentType(let acceptableContentTypes):
                    errorMessage += ", Content Type Missing: \(acceptableContentTypes)"
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    errorMessage += ", Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                case .unacceptableStatusCode(let code):
                    errorMessage += ", Response status code was unacceptable: \(code)"
                    errorCode = code
                }
            case .responseSerializationFailed(let reason):
                errorMessage = "Response serialization failed: \(error.localizedDescription)"
                errorMessage += "- Failure Reason: \(reason)"
            }
            
        }
        return (errorMessage, errorCode)
    }
    
    //------------------------------------------------------------------------------
    // MARK: Responses
    //------------------------------------------------------------------------------
    func didReceive(ID: String, result: JSON) {
        if let request = getRequest(ID) {
            request.completion(.Success(data: result))
            deleteRequest(ID)
        } else {
            print("API didReceive missing request")
        }
    }
    
    func didFail(ID: String, error: String, code: Int?) {
        print(error.description)
        if let request = getRequest(ID) {
            if request.retryCount > 0 {
                print("API error - retrying:\(error), code:\(String(describing: code)), ID:\(ID)")
                deleteRequest(ID)
                requestWithRetries(ID: request.ID, url: request.url, params: request.params, maxRetry: request.retryCount - 1, type: request.method, completion: request.completion)
            } else {
                print("API error - fail:\(error), code:\(String(describing: code)), ID:\(ID)")
                request.completion(.Error((error:error, code:code != nil ? code! : -1, message:ID)))
                deleteRequest(ID)
            }
        } else {
            print("API didFail missing request")
        }
    }

    //------------------------------------------------------------------------------
    // MARK: Request Queue
    //------------------------------------------------------------------------------
    fileprivate func addToRequestQueue(_ alamoRequest: DataRequest, _ ID: String, _ url: URL, _ params: [String : Any]?, _ headers: [String : String]?, _ maxRetry: Int, _ type:HTTPMethod, _ completion: @escaping jsonCompletion) {
        print("request body: \(alamoRequest.debugDescription)")
        let request = APIRequest(ID:ID, url:url, method:type, parameters: params, headers: headers, retryCount:maxRetry, request: alamoRequest, completion:completion)
        addRequest(request)
    }
    
    let safeSerialQueue = DispatchQueue(label: "SerialQueueSafety", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)
    var _currentQueue:[String:APIRequest] = [:]
    
    func getRequest(_ key:String) -> APIRequest? {
        var foundRequest:APIRequest? = nil
        safeSerialQueue.sync {
            foundRequest = _currentQueue[key]
        }
        return foundRequest
    }
    
    func deleteRequest(_ key:String) {
        safeSerialQueue.async(flags:.barrier) {
            self._currentQueue[key] = nil
        }
    }
    
    func addRequest(_ request:APIRequest) {
        safeSerialQueue.async(flags:.barrier) {
            self._currentQueue[request.ID] = request
        }
        
    }
    
    class APIRequest: NSObject {
        let ID:String
        let url:URL
        let method:HTTPMethod
        let headers:[String:String]?
        let params:[String:Any]?
        var retryCount:Int = 0
        let request:DataRequest
        let completion:jsonCompletion
        
        init(ID:String, url:URL, method:HTTPMethod, parameters:[String:Any]?, headers:[String:String]?, retryCount:Int, request:DataRequest, completion:@escaping jsonCompletion) {
            self.ID = ID
            self.url = url
            self.method = method
            self.headers = headers
            self.params = parameters
            self.retryCount = retryCount
            self.request = request
            self.completion = completion
        }
    }
}

