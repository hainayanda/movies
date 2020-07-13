//
//  APIRequest.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire
import NamadaJSON

public class APIRequest: Initiable {
    public var url: String = ""
    public var urlWithParam: String {
        guard urlParams.count > 0 else { return url }
        var url = "\(self.url)?"
        for (key, value) in urlParams {
            url = "\(url)\(key)=\(value)&"
        }
        let _ = url.popLast()
        return url
    }
    public var method: Alamofire.HTTPMethod = .get
    public var urlParams: [String: String] = [:]
    private var _params: Parameters?
    public var params: Parameters? {
        get {
            return _params
        }
        set {
            _params = newValue
            _objectParams = nil
        }
    }
    private var _objectParams: JSONAble?
    public var objectParams: JSONAble? {
        get {
            return _objectParams
        }
        set {
            _params = newValue?.toJSON()
            _objectParams = newValue
        }
    }
    public var encoding: ParameterEncoding = JSONEncoding.default
    public var headers: HTTPHeaders = [:]
    
    required public init() {}
}

