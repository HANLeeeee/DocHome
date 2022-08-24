//
//  APIManager.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation
import Alamofire

enum APIManager: URLRequestConvertible {
    case searchKeyword(keyword: String, x: String, y: String)
    case searchCategory(x: String, y: String)
    
    var baseURL: URL {
        return URL(string: Constants.APIURL.KakaoAPI.searchURL)!
    }
    
    var endPoint: String {
        switch self {
        case .searchKeyword:
            return "/keyword.json"
        case .searchCategory:
            return "/category.json"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default:
            let headers: HTTPHeaders = [
                "Accept": "*/*",
                "Authorization": "KakaoAK d94bc5225be67c27460132ba4155d4da"
            ]
            return headers
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .searchKeyword(let keyword, let x, let y):
            var params = Parameters()
            params["query"] = keyword
            params["category_group_code"] = Constants.APIURL.KakaoAPI.category_group_code.hospital
            params["x"] = x
            params["y"] = y
            params["radius"] = "20000"

            return params
            
        case .searchCategory(let x, let y):
            var params = Parameters()
            params["category_group_code"] = Constants.APIURL.KakaoAPI.category_group_code.hospital
            params["x"] = x
            params["y"] = y
            params["radius"] = "20000"
            
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        
        request.headers = headers
        request.method = method
        
        request = try URLEncoding.default.encode(request, with: parameters)

        return request
    }
}
