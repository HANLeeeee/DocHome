//
//  APIExecute.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation

class APIExecute {
    static let shared: APIExecute = {
        return APIExecute()
    }()
    
    func searchCategoryRequest<T: Decodable>(x: Double, y: Double, page: Int, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = APIManager.searchCategory(x: x, y: y, page: page).asURLRequest() else { return }
        execute(request, completion)
    }
    
    func searchKeywordRequest<T: Decodable>(keyword: String, x: Double, y: Double, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = APIManager.searchKeyword(keyword: keyword, x: x, y: y).asURLRequest() else { return }
        execute(request, completion)
    }
    
    func execute<T: Decodable>(_ request: URLRequest, _ completion: @escaping (Result<T, Error>) -> Void ) {
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
            guard let result: T = try? JSONDecoder().decode(T.self, from: data) else {
                print("searchKeywordAPI Error: JSON Data Parsing failed")
                return
            }
            completion(.success(result))
        }
        task.resume()
    }
}
