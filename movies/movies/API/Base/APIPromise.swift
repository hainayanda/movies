//
//  APIPromise.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire

public protocol Promise {
    associatedtype Result
    
    func then(run closure: @escaping (Result) -> Void, whenFailed failClosure: @escaping (Error) -> Void)
    func then(run closure: @escaping (Result) -> Void)
}

open class JSONAPIPromise<JSONType: JSONParseable>: Promise {
    
    public typealias Result = APIResult<JSONType>
    
    var request: DataRequest?
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    public init(request: DataRequest?) {
        self.request = request
    }
    
    open func then(run closure: @escaping (Result) -> Void, whenFailed failClosure: @escaping (Error) -> Void) {
        guard isConnectedToInternet else {
            runOnMainThread {
                failClosure(APIError(description: "No Internet"))
            }
            return
        }
        guard let request = request else {
            runOnMainThread {
                failClosure(APIError(description: "No Request"))
            }
            return
        }
        request.validate(statusCode: 200..<300).responseJSON { response in
            dispatchOnMainThread {
                if let error = response.error {
                    failClosure(error)
                } else {
                    closure(APIResult(raw: response))
                }
            }
        }
    }
    
    open func then(run closure: @escaping (Result) -> Void) {
        guard isConnectedToInternet, let request = request else {
            return
        }
        request.validate(statusCode: 200..<300).responseJSON { response in
            dispatchOnMainThread {
                closure(APIResult(raw: response))
            }
        }
    }
    
}
