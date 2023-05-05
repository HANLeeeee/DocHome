//
//  SearchAPI.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation

class API {
    static let shared: API = {
            return API()
    }()
    
    func searchKeywordAPI(keyword: String, x: Double, y: Double, completion: @escaping (SearchResponse) -> Void) {
        APIManager.searchKeyword(keyword: keyword, x: x, y: y).asURLRequest(completion: { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("searchKeywordAPI Error: error calling GET")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("searchKeywordAPI Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                    print("searchKeywordAPI Error: HTTP request failed")
                    return
                }
                guard let result = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
                    print("searchKeywordAPI Error: JSON Data Parsing failed")
                    return
                }
                completion(result)
            }
            task.resume()
        })
    }
    
    func searchCategoryAPI(x: Double, y: Double, completion: @escaping (SearchResponse) -> Void) {
        APIManager.searchCategory(x: x, y: y).asURLRequest(completion: { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("searchCategoryAPI Error: error calling GET")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("searchCategoryAPI Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                    print("searchCategoryAPI Error: HTTP request failed")
                    return
                }
                guard let result = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
                    print("searchCategoryAPI Error: JSON Data Parsing failed")
                    return
                }
                completion(result)
            }
            task.resume()
        })
    }
    
    
    
//    func searchKeywordAPI(keyword: String, x: String, y: String, completion: @escaping (Result<SearchResponse, AFError>) -> Void) {
//        AF.request(APIManager.searchKeyword(keyword: keyword, x: x, y: y))
//            .validate()
//            .responseDecodable(of: SearchResponse.self) { response in
//            switch response.result {
//            case .success(let result):
//                completion(.success(result))
//
//            case .failure(let error):
//                print("리스폰스에러 searchKeywordAPI \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func searchCategoryAPI(x: String, y: String, completion: @escaping (Result<SearchResponse, AFError>) -> Void) {
//        AF.request(APIManager.searchCategory(x: x, y: y))
//            .validate()
//            .responseDecodable(of: SearchResponse.self) { response in
//            switch response.result {
//            case .success(let result):
//                completion(.success(result))
//
//            case .failure(let error):
//                print("리스폰스에러 searchCategoryAPI \(error.localizedDescription)")
//            }
//        }
//    }
}
