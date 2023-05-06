//
//  APIManager.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation

enum APIManager {
    case searchKeyword(keyword: String, x: Double, y: Double)
    case searchCategory(x: Double, y: Double, page: Int)
    
    var endPoint: String {
        switch self {
        case .searchKeyword:
            return "/v2/local/search/keyword.json"
        case .searchCategory:
            return "/v2/local/search/category.json"
        }
    }
    
    var headers: [String: String] {
        switch self {
        default:
            let headers = [
                "Accept": "*/*",
                "Authorization": "KakaoAK d94bc5225be67c27460132ba4155d4da"
            ]
            return headers
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .searchKeyword(let keyword, let x, let y):
            let params = [URLQueryItem(name: "query", value: "\(keyword)"),
                          URLQueryItem(name: "category_group_code", value:
                                        "\(Constants.APIURL.KakaoAPI.category_group_code.hospital)"),
                          URLQueryItem(name: "x", value: "\(x)"),
                          URLQueryItem(name: "y", value: "\(y)"),
                          URLQueryItem(name: "radius", value: "\(20000)"),
                          URLQueryItem(name: "sort", value: "distance")]
            
            return params
            
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
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    func asURLRequest(completion: @escaping (URLRequest) -> Void) {
        guard var urlComponents = URLComponents(string: Constants.APIURL.KakaoAPI.searchURL) else { return }
        
        urlComponents.path = endPoint
        urlComponents.queryItems = parameters
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = method
        
        completion(request)
    }
}

/* alamofire 사용 시
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
                "Accept": "*//*", -/슬래시 하나 지우기
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
            params["sort"] = "distance"

            return params

        case .searchCategory(let x, let y):
            var params = Parameters()
            params["category_group_code"] = Constants.APIURL.KakaoAPI.category_group_code.hospital
            params["x"] = x
            params["y"] = y
            params["radius"] = "20000"
            params["sort"] = "distance"

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
*/
