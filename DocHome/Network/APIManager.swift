//
//  APIManager.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation

enum APIManager {
    case searchCategory(x: Double, y: Double, page: Int)
    case searchKeyword(keyword: String, x: Double, y: Double)
    
    var endPoint: String {
        switch self {
        case .searchCategory:
            return "/v2/local/search/category.json"
        case .searchKeyword:
            return "/v2/local/search/keyword.json"
        }
    }
    
    var headers: [String: String] {
        switch self {
        default:
            let headers = [
                "Accept": "*/*",
                "Authorization": Bundle.main.kakaoAuthKey
            ]
            return headers
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .searchCategory(let x, let y, let page):
            let params = [URLQueryItem(name: "category_group_code", value:
                                        "\(Constants.APIURL.KakaoAPI.category_group_code.hospital)"),
                          URLQueryItem(name: "x", value: "\(x)"),
                          URLQueryItem(name: "y", value: "\(y)"),
                          URLQueryItem(name: "radius", value: "\(20000)"),
                          URLQueryItem(name: "sort", value: "distance"),
                          URLQueryItem(name: "page", value: "\(page)"),
                          URLQueryItem(name: "size", value: "10")]
            
            return params
            
            
        case .searchKeyword(let keyword, let x, let y):
            let params = [URLQueryItem(name: "query", value: "\(keyword)"),
                          URLQueryItem(name: "category_group_code", value:
                                        "\(Constants.APIURL.KakaoAPI.category_group_code.hospital)"),
                          URLQueryItem(name: "x", value: "\(x)"),
                          URLQueryItem(name: "y", value: "\(y)"),
                          URLQueryItem(name: "radius", value: "\(20000)"),
                          URLQueryItem(name: "sort", value: "accuracy")]
            
            return params
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    func asURLRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.APIURL.KakaoAPI.searchURL) else { return nil }
        
        urlComponents.path = endPoint
        urlComponents.queryItems = parameters
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = method
        
        return request
    }
}
