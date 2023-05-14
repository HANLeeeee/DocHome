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
    case httprequest(statusCode: Int)
    case jsonDataParsing

    var description: String {
        switch self {
        case .callingError(let errorContent): return "오류 호출, 오류내용: \(errorContent)"
        case .receiveData: return "데이터 수신 오류"
        case .httprequest(let statusCode): return "HTTP 요청 오류: \(statusCode)"
        case .jsonDataParsing: return "JSON 데이터 파싱 오류"
        }
    }
}

class APIExecute {
    static let shared: APIExecute = {
        return APIExecute()
    }()
    
    func searchCategoryRequest<T: Decodable>(isPaging: Bool = false, x: Double, y: Double, page: Int, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + (isPaging ? 0 : 1)) { [self] in
            guard let request = APIManager.searchCategory(x: x, y: y, page: page).asURLRequest() else { return }
            execute(isPaging, request, completion)
        }
    }
    
    func searchKeywordRequest<T: Decodable>(keyword: String, x: Double, y: Double, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global().async { [self] in
            guard let request = APIManager.searchKeyword(keyword: keyword, x: x, y: y).asURLRequest() else { return }
            execute(false, request, completion)
        }
    }
    
    func execute<T: Decodable>(_ isPaging: Bool, _ request: URLRequest, _ completion: @escaping (Result<T, Error>) -> Void ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(ExecuteError.callingError(errorContent: "\(error!)"))
                return
            }
            guard let data = data else {
                print(ExecuteError.receiveData)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print(ExecuteError.httprequest(statusCode: 0))
                return
            }
            guard (200..<300).contains(response.statusCode) else {
                print(ExecuteError.httprequest(statusCode: response.statusCode))
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
