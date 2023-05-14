//
//  APIExecute.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation

enum ExecuteError: CustomStringConvertible {
    case callingError(errorContent: String)
    case receiveData
    case httprequest
    case jsonDataParsing

    var description: String {
        switch self {
        case .callingError(let errorContent): return "오류 호출, 오류내용: \(errorContent)"
        case .receiveData: return "데이터 수신 오류"
        case .httprequest: return "HTTP 요청 오류"
        case .jsonDataParsing: return "JSON 데이터 파싱 오류"
        }
    }
}

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
                print(ExecuteError.callingError(errorContent: "\(error!)"))
                return
            }
            guard let data = data else {
                print(ExecuteError.receiveData)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print(ExecuteError.httprequest)
                return
            }
            guard let result: T = try? JSONDecoder().decode(T.self, from: data) else {
                print(ExecuteError.jsonDataParsing)
                return
            }
            completion(.success(result))
        }
        task.resume()
    }
}
